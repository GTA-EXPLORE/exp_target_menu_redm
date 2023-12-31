function AddTypeMenuItem(data)
    options[TYPE_TO_OPTION[data.type]][data.event] = {
        desc = data.desc or _("no_desc"),
        stay = data.stay,
        arguments = data.arguments
    }
end
exports("AddTypeMenuItem", AddTypeMenuItem)

function RemoveTypeMenuItem(data)
    options[TYPE_TO_OPTION[data.type]][data.event] = nil
end
exports("RemoveTypeMenuItem", RemoveTypeMenuItem)

function AddEntityMenuItem(data)
    reg_entities[data.entity] = reg_entities[data.entity] or {}
    reg_entities[data.entity][data.event] = {
        desc = data.desc or _("no_desc"),
        stay = data.stay,
        arguments = data.arguments
    }
    if data.name then
        SetEntityName(data)
    end
end
exports("AddEntityMenuItem", AddEntityMenuItem)

function RemoveEntityMenuItem(data)
    if not reg_entities[data.entity] then return end
    
    reg_entities[data.entity][data.event] = nil

    local is_empty = true
    for k, v in pairs(reg_entities[data.entity]) do
        is_empty = false
        break
    end
    if is_empty then
        reg_entities[data.entity] = nil
    end
end
exports("RemoveEntityMenuItem", RemoveEntityMenuItem)

function AddModelMenuItem(data)
    reg_models[data.model] = reg_models[data.model] or {}
    reg_models[data.model][data.event] = {
        desc = data.desc or _("no_desc"),
        stay = data.stay,
        arguments = data.arguments
    }
    
    if data.name then
        SetEntityName(data)
    end
end
exports("AddModelMenuItem", AddModelMenuItem)

function RemoveModelMenuItem(data)
    if not reg_models[data.model] then return end

    reg_models[data.model][data.event] = nil

    local is_empty = true
    for k, v in pairs(reg_models[data.model]) do
        is_empty = false
        break
    end
    if is_empty then
        reg_models[data.model] = nil
    end
end
exports("RemoveModelMenuItem", RemoveModelMenuItem)

function PauseMenu(data)
    paused = data.pause
    SendNUIMessage({
        action = "FORCE_CLOSE"
    })
end
exports("PauseMenu", PauseMenu)

function OpenMainMenu(data)
    interacting = true
    SendNUIMessage({
        action = "OPEN_MENU",
        title = data.name,
        options = data.options or entity_options
    })
    SetNuiFocus(true, true)
end
exports("OpenMainMenu", OpenMainMenu)

function SetEntityName(data)
    reg_names[data.entity] = data.name
end
exports("SetEntityName", SetEntityName)

function SetModelName(data)
    reg_model_names[data.model] = data.name
end
exports("SetModelName", SetModelName)

function SetModelOffset(data)
    reg_model_offsets[data.model] = data.offset
end
exports("SetModelOffset", SetModelOffset)