local LOCATIONS = {
    {   -- VALENTINE
        position = vector3(-325.5, 774.57, 117.45),
        heading = 0.0
    },
    {   -- RHODES
        position = vector3(1225.60, -1293.85, 76.90),
        heading = 0.0
    },
    {   -- SAINT DENIS
        position = vector3(2550.81, -1166.28, 53.68),
        heading = 0.0
    },
    {   -- BLACK WATER
        position = vector3(-767.94, -1294.95, 43.84),
        heading = 0.0
    },
    {   -- STRAWBERRY
        position = vector3(-1794.89, -385.22, 159.33),
        heading = 0.0
    }
}

Citizen.CreateThread(function()
    local model = "s_m_m_tailor_01"
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(100) end

    for i,v in ipairs(LOCATIONS) do
        local ped = CreatePed(GetHashKey(model), v.position, v.heading, false, false)
        Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
        SetBlockingOfNonTemporaryEvents(ped, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TriggerEvent("exp_target_menu:AddEntityMenuItem", ped, "exp_target_menu:OpenClothingShop", "Shop", false)
        TriggerEvent("exp_target_menu:SetEntityName", ped, "Clothing Store")
    end
end)

AddEventHandler("exp_target_menu:OpenClothingShop", function(entity)
    TriggerServerEvent("redemrp_clothing:loadClothes", 2)
end)

AddEventHandler("exp_target_menu:OpenOutfits", function(entity)
    TriggerEvent('redemrp_clothing:OpenOutfits')
end)
TriggerEvent("exp_target_menu:AddModelMenuItem", -370296889, "exp_target_menu:OpenOutfits", "Change Outfit", false)
TriggerEvent("exp_target_menu:SetModelName", -370296889, "Cloackroom")
TriggerEvent("exp_target_menu:SetModelOffset", -370296889, vector3(0,0,1.5))