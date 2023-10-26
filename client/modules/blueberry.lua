local BUSH_MODELS = {477619010, 85102137, -1707502213}
local old_bushes = {}
AddEventHandler("exp_target_menu:HarvestBush", function(entity)
    if old_bushes[entity] then return end

    old_bushes[entity] = true
    local ped = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do Wait(100) end
    TaskPlayAnim(ped, "mech_pickup@plant@berries", "enter_lf", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(GetAnimDuration("mech_pickup@plant@berries", "enter_lf")*1000)
    TaskPlayAnim(ped, "mech_pickup@plant@berries", "base", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(GetAnimDuration("mech_pickup@plant@berries", "base")*1000)
    TriggerServerEvent('exp_target_menu:addBlueBerry')
    ClearPedTasks(ped)
end)

for i,v in ipairs(BUSH_MODELS) do
    TriggerEvent("exp_target_menu:AddModelMenuItem", v, "exp_target_menu:HarvestBush", "Harvest", false)
    TriggerEvent("exp_target_menu:SetModelName", v, "Blueberries")
    TriggerEvent("exp_target_menu:SetModelOffset", v, vector3(0, 0, 1.0))
end

local amount = 0
RegisterNetEvent('exp_target_menu:EatBlueBerry')
AddEventHandler('exp_target_menu:EatBlueBerry', function()
    local ped = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
        Wait(100)
    end
    TaskPlayAnim(ped, "mech_pickup@plant@berries", "exit_eat", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2500)
    TriggerServerEvent('wwrp_status:eatberry')
    amount = amount + 1
    if amount == 4  then
        TriggerEvent("redem_roleplay:Tip", "Do not eat blueberries too often, this can result in poisoning!", 4000)
    end
    if amount > 4 then
        Wait(2300)
        StartPoison()
    end
    ClearPedTasks(ped)
end)

function StartPoison()
    local dict = "amb_misc@world_human_vomit_kneel@male_a@idle_c"
    local anim = "idle_g"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    local test = 10
    Citizen.CreateThread(function()
        while test > 0 do
            if not IsEntityPlayingAnim( PlayerPedId() ,dict, anim, 31) then
                TaskPlayAnim( PlayerPedId(), dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            end
            Wait(2000)
            local hp = GetEntityHealth(PlayerPedId())
            SetEntityHealth(PlayerPedId(),hp-5)
            test = test - 1
        end
        ClearPedTasksImmediately(PlayerPedId())
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        amount = math.max(0, amount - 1)
    end
end)