--          _____                    _____                    _____                    _____                    _____          
--         /\    \                  /\    \                  /\    \                  /\    \                  /\    \         
--        /::\____\                /::\    \                /::\    \                /::\____\                /::\    \        
--       /::::|   |                \:::\    \              /::::\    \              /:::/    /                \:::\    \       
--      /:::::|   |                 \:::\    \            /::::::\    \            /:::/    /                  \:::\    \      
--     /::::::|   |                  \:::\    \          /:::/\:::\    \          /:::/    /                    \:::\    \     
--    /:::/|::|   |                   \:::\    \        /:::/  \:::\    \        /:::/____/                      \:::\    \    
--   /:::/ |::|   |                   /::::\    \      /:::/    \:::\    \      /::::\    \                      /::::\    \   
--  /:::/  |::|   | _____    ____    /::::::\    \    /:::/    / \:::\    \    /::::::\____\________    ____    /::::::\    \  
-- /:::/   |::|   |/\    \  /\   \  /:::/\:::\    \  /:::/    /   \:::\    \  /:::/\:::::::::::\    \  /\   \  /:::/\:::\    \ 
--/:: /    |::|   /::\____\/::\   \/:::/  \:::\____\/:::/____/     \:::\____\/:::/  |:::::::::::\____\/::\   \/:::/  \:::\____\
--\::/    /|::|  /:::/    /\:::\  /:::/    \::/    /\:::\    \      \::/    /\::/   |::|~~~|~~~~~     \:::\  /:::/    \::/    /
-- \/____/ |::| /:::/    /  \:::\/:::/    / \/____/  \:::\    \      \/____/  \/____|::|   |           \:::\/:::/    / \/____/ 
--         |::|/:::/    /    \::::::/    /            \:::\    \                    |::|   |            \::::::/    /          
--         |::::::/    /      \::::/____/              \:::\    \                   |::|   |             \::::/____/           
--         |:::::/    /        \:::\    \               \:::\    \                  |::|   |              \:::\    \           
--         |::::/    /          \:::\    \               \:::\    \                 |::|   |               \:::\    \          
--         /:::/    /            \:::\    \               \:::\    \                |::|   |                \:::\    \         
--        /:::/    /              \:::\____\               \:::\____\               \::|   |                 \:::\____\        
--        \::/    /                \::/    /                \::/    /                \:|   |                  \::/    /        
--         \/____/                  \/____/                  \/____/                  \|___|                   \/____/        

-------------------------------------------------
--                BASIC CHOICE                 --
-------------------------------------------------

function LocalPed()
    return GetPlayerPed(-1)
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
				local playerCoords = GetEntityCoords(LocalPed())
				local ped = GetPlayerPed(-1)
				local pos = GetEntityCoords(PlayerPedId())
				for k,v in pairs(config.policegaragespot) do
				if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.x, v.y, v.z, true ) < 5 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    DrawMarker(21, v.x,v.y,v.z-0.40, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 48, 3, 105, 100, false, true, 2, true, false, false, false)
					if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.x, v.y, v.z, true ) < 2 then
						DrawText3Ds(v.x,v.y,v.z, config.Language.Text, 3.0, 7)
                        if IsControlJustPressed(1, 47) then
                        TriggerServerEvent("nicki_politigaragev2:checkPermission")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('nicki_politigaragev2:repairVehicle')
AddEventHandler('nicki_politigaragev2:repairVehicle', function()
    vehicle = GetVehiclePedIsIn(LocalPed())
    exports['progressBars']:startUI(3000, config.Language.RepairVeh)
    FreezeEntityPosition(vehicle, true)
    Citizen.Wait(3000)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleBodyHealth(vehicle, 9999)
    SetVehicleFixed(vehicle)
    FreezeEntityPosition(vehicle, false)
    exports['mythic_notify']:SendAlert('success', config.Language.RepairedNow)
end)

RegisterNetEvent('nicki_politigaragev2:washVehicle')
AddEventHandler('nicki_politigaragev2:washVehicle', function()
      vehicle = GetVehiclePedIsIn(LocalPed())
      exports['progressBars']:startUI(3000, config.Language.WashVeh)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(3000)
      SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),false), 0.0)
      SetVehicleUndriveable(GetVehiclePedIsIn(GetPlayerPed(-1),false), false)
      exports['mythic_notify']:SendAlert('inform', config.Language.WashedNow)
      FreezeEntityPosition(vehicle, false)
end)

RegisterNetEvent('nicki_politigaragev2:parkVehicle')
AddEventHandler('nicki_politigaragev2:parkVehicle', function()
      vehicle = GetVehiclePedIsIn(LocalPed())
      SetEntityAsMissionEntity(vehicle, true,true)
      TaskLeaveVehicle(PlayerPedId(), vehicle)
      Citizen.Wait(1500)
      DeleteVehicle(vehicle, false)
      exports['mythic_notify']:SendAlert('success', config.Language.ParkedVeh)
end)

-------------------------------------------------
--                     UI                      --
-------------------------------------------------

RegisterNetEvent("nicki_politigaragev2:OpenUIMenu")
AddEventHandler("nicki_politigaragev2:OpenUIMenu", function ()
    SetNuiFocus(true, true)
    Citizen.Wait(100)
    SendNUIMessage({
        type = "openUIMenu",
    })
end)

RegisterNUICallback("CloseMenu", function (data, callback)
    SetNuiFocus(false, false)
    callback("ok")
end)

RegisterNUICallback("Choose1", function (data, callback)
    SetNuiFocus(false, false)
    callback("ok")
    TriggerEvent("nicki_politigaragev2:repairVehicle")
end)

RegisterNUICallback("Choose2", function (data, callback)
    SetNuiFocus(false, false)
    callback("ok")
    TriggerEvent("nicki_politigaragev2:washVehicle")
end)

RegisterNUICallback("Choose3", function (data, callback)
    SetNuiFocus(false, false)
    callback("ok")
    TriggerEvent("nicki_politigaragev2:parkVehicle")
end)

---------- 3D Text ----------
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
                end

function CreateMissionBlip()
    local blip = AddBlipForCoord(Lokation)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    AddTextEntry('1234', "1234")
    BeginTextCommandSetBlipName('1234')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    SetBlipScale(blip, 0.9) -- set scale
    SetBlipAsShortRange(blip, true)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end                
