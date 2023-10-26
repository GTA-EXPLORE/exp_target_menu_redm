AddEventHandler("exp_target_menu:AnimateSit", function()
    local ped = PlayerPedId()
    local dict, anim = "amb_rest_sit@world_human_depressed_sit_ground@male_a@idle_b", "idle_e"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(100) end
    local in_anim = true
    Citizen.CreateThread(function()
        local duration = GetAnimDuration(dict, anim)
        while in_anim do 
            TaskPlayAnim(ped, dict, anim, 1.0, 1.0, duration, 0, 1, true, 0, false, 0, false)
            Wait(duration*1000)
        end
    end)
    while in_anim do Wait(50)
        if IsControlJustPressed(0, 0x7065027D) -- LEFT
        or IsControlJustPressed(0, 0x8FD015D8) -- UP
        or IsControlJustPressed(0, 0xD27782E3) -- DOWN
        or IsControlJustPressed(0, 0xB4E465B4) then -- RIGHT
            ClearPedTasks(ped)
            in_anim = false
        end
    end
end)
TriggerEvent("exp_target_menu:AddTypeMenuItem", "exp_target_menu:AnimateSit", "all", "Sit down", false)