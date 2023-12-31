rc_hit, rc_entity, rc_coords = nil, nil, nil
show_cursor, paused, interacting, cursor_active = false, false, false, false
player, reg_entities, reg_models, reg_names, reg_model_names, reg_model_offsets = {}, {}, {}, {}, {}, {}
TYPE_TO_OPTION = {all = 0, ped = 1, vehicle = 2, object = 3, player = "player", in_vehicle = "in_vehicle"}

local options = {
    [0] = { -- all
        ["redemrp_inventory:ToggleInventory"] = {
            desc = "Open Inventory",
            stay = false
        }
    },
    [1] = { -- peds
    },
    [2] = { -- vehicle
    },
    [3] = { -- object
    },
    ["player"] = {
    },
    ["in_vehicle"] = {
    }
}

entity_options = options[0]

Citizen.CreateThread(function()
    RequestStreamedTextureDict(ENTITY_SPRITE.DICT)
    RequestStreamedTextureDict(ENTITY_SPRITE_HOVER.DICT)
end)

Citizen.CreateThread(function()
    local _KEY_CURSOR = joaat(KEY_CURSOR)
    while true do Wait(1)
        if IsControlPressed(0, _KEY_CURSOR) then
            ExecuteCommand("+track")
            while IsControlPressed(0, _KEY_CURSOR) do Wait(1) end
            ExecuteCommand("-track")
        end
    end
end)

RegisterCommand("+track", function()
    if show_cursor or interacting or paused then return end
    show_cursor = true
    
    player.Ped = PlayerPedId()

    SendNUIMessage({
        action = "SHOW_CURSOR",
        toggle = true
    })
    StartTracker()

    Citizen.CreateThread(function()
        while show_cursor do Wait(0)
            DisableControlAction(0, 0x07CE1E61, true) -- INPUT_ATTACK (LEFT CLICK)
            DisablePlayerFiring(PlayerId(), true)
            if IsDisabledControlJustReleased(0, 0x07CE1E61) then
                OnClick()
            end
        end
    end)
    
    while (show_cursor or interacting) and not IsPlayerFreeAiming(PlayerId()) do
        ShowEntities()
        Wait(0)
    end
    show_cursor, interacting = false, false
    SendNUIMessage({
        action = "SHOW_CURSOR",
        toggle = false
    })
    SetNuiFocus(false, false)
end)
RegisterCommand("-track", function()
    show_cursor = false
end)

function OnClick()
    local target = rc_entity
    local ent_options = {}
    local name = reg_names[target] or reg_model_names[GetEntityModel(target)] or _("entity_type_name_"..GetEntityType(target))

    if not cursor_active then
        if not DoesEntityExist(target) then
            if IsPedInAnyVehicle(player.Ped) then
                ent_options = options["in_vehicle"]
                name = _("entity_type_name_in_vehicle")
            else
                ent_options = options[0]
            end
        else
            return
        end
    else
        if IsPedAPlayer(target) then
            ent_options = options["player"]
        else
            if options[GetEntityType(target)] then ent_options = MergeDict(ent_options, options[GetEntityType(target)]) end
            -- if GetEntityType(target) == 1 and not IsEntityPositionFrozen(target) then ent_options["turfwars:SellDrug"] = {desc = "Sell Drugs"} end
            if reg_models[GetEntityModel(target)] then ent_options = MergeDict(ent_options, reg_models[GetEntityModel(target)]) end
            if reg_entities[target] then ent_options = MergeDict(ent_options, reg_entities[target]) end
        end
    end

    SendNUIMessage({
        action = "OPEN_MENU",
        title = name,
        options = ent_options
    })
    interacting = true
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    
    Citizen.CreateThread(function()
        if IsEntityAPed(target) and not IsPedAPlayer(target) then
            -- PlayPedAmbientSpeechNative(target, "GENERIC_HI", "SPEECH_PARAMS_STANDARD")
            if not reg_entities[target] and IsPedHuman(target) then
                TaskTurnPedToFaceEntity(target, player.Ped, 1000)
                while interacting do Wait(1000)
                    TaskStandStill(target, 1000)
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while interacting do Wait(1)
            DisableAllControlActions()
        end
    end)
end

function ShowEntities()
    player.Coords = GetEntityCoords(player.Ped)
    local entities = {}
    cursor_active = false

    for _, ent in ipairs(GetObjects()) do
        local ent_model = GetEntityModel(ent)
        if (reg_entities[ent] or reg_models[ent_model]) and #(player.Coords - GetEntityCoords(ent)) < 10 then
            local ent_coords = GetOffsetFromEntityInWorldCoords(ent, reg_model_offsets[ent_model] or vector3(0,0,0))
            if ent == rc_entity then
                
                local screen_x, screen_y = DrawSpriteAtCoords(ENTITY_SPRITE_HOVER, ent_coords)
                cursor_active = cursor_active or AreCoordsCentered(screen_x, screen_y)
            else
                DrawSpriteAtCoords(ENTITY_SPRITE, ent_coords)
            end
        end
    end
    for _, ent in ipairs(GetPeds()) do
        local ent_coords = GetOffsetFromEntityInWorldCoords(ent, reg_model_offsets[GetEntityModel(ent)] or vector3(0,0,0))
        if #(player.Coords - ent_coords) < 10 then
            if ent == rc_entity then
                local screen_x, screen_y = DrawSpriteAtCoords(ENTITY_SPRITE_HOVER, vector3(ent_coords.x, ent_coords.y, ent_coords.z+0.3))
                cursor_active = cursor_active or AreCoordsCentered(screen_x, screen_y)
            else
                DrawSpriteAtCoords(ENTITY_SPRITE, vector3(ent_coords.x, ent_coords.y, ent_coords.z+0.3))
            end
        end
    end    
    for _, ent in ipairs(GetVehicles()) do
        if #(player.Coords - GetEntityCoords(ent)) < 10 then
            local ent_coords = GetOffsetFromEntityInWorldCoords(ent, reg_model_offsets[GetEntityModel(ent)] or vector3(0,0,0))
            if ent == rc_entity then
                local screen_x, screen_y = DrawSpriteAtCoords(ENTITY_SPRITE_HOVER, ent_coords)
                cursor_active = cursor_active or AreCoordsCentered(screen_x, screen_y)
            else
                DrawSpriteAtCoords(ENTITY_SPRITE, ent_coords)
            end
        end
    end
    
    if not interacting then
        SendNUIMessage({
            action = "SET_CURSOR_ACTIVE",
            toggle = cursor_active
        })
    end
end

function StartTracker()
    Citizen.CreateThread(function()
        while show_cursor or interacting do 
            rc_hit, rc_coords, rc_entity = RayCastGamePlayCamera(10)
            Wait(100)
        end
    end)
end

function AreCoordsCentered(screen_x, screen_y)
    return math.abs(screen_x-0.5) < 0.01 and math.abs(screen_y-0.5) < 0.01
end

RegisterNUICallback("Trigger", function(data, cb)
    TriggerEvent(data.event, rc_entity, data.data.arguments)
end)

RegisterNUICallback("Close", function()
    Close()
end)

function Close()
    interacting = false
end