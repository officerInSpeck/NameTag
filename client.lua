local radarEsteso = false
local mostrablip = false
local mostranomi = false

RegisterNetEvent('mostraBlips')
AddEventHandler('mostraBlips', function()
    mostrablip = not mostrablip
    if mostrablip then
        mostrablip = true

    else
        mostrablip = false
    end
end)

RegisterNetEvent('mostraNomi')
AddEventHandler('mostraNomi', function()
    mostranomi = not mostranomi
    if mostranomi then
        mostranomi = true
    else
        mostranomi = false
    end
end)

Citizen.CreateThread(function()
    while true do
    Wait(1)
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
            ped = GetPlayerPed(i)
            blip = GetBlipFromEntity(ped)
            idTesta = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(i), false, false, "", false)

            if mostranomi then
                Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, true) 
                if NetworkIsPlayerTalking(i) then
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, true)
                else
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, false)
                end
            else 
                Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, false)
                Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, false)
            end

            if mostrablip then
                if not DoesBlipExist(blip) then 
                    blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip, 1) 
                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) 
                else 
                    veh = GetVehiclePedIsIn(ped, false) 
                    blipSprite = GetBlipSprite(blip)
                    if not GetEntityHealth(ped) then 
                        if blipSprite ~= 274 then
                            SetBlipSprite(blip, 274)
                            Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                        end
                    elseif veh then 
                        calsseVeicolo = GetVehicleClass(veh)
                        modelloVeicolo = GetEntityModel(veh)
                        if calsseVeicolo == 15 then
                            if blipSprite ~= 422 then 
                                SetBlipSprite(blip, 422) 
                                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                            end
                        elseif calsseVeicolo == 16 then 
                            if modelloVeicolo == GetHashKey("besra") or modelloVeicolo == GetHashKey("hydra") or modelloVeicolo == GetHashKey("lazer") then 
                                if blipSprite ~= 424 then
                                    SetBlipSprite(blip, 424)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                end
                            elseif blipSprite ~= 423 then
                                SetBlipSprite(blip, 423)
                                Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false) 
                            end
                        elseif calsseVeicolo == 14 then 
                            if blipSprite ~= 427 then
                                SetBlipSprite(blip, 427)
                                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                            end
                        elseif modelloVeicolo == GetHashKey("insurgent") or modelloVeicolo == GetHashKey("insurgent2") or modelloVeicolo == GetHashKey("limo2") then
                                if blipSprite ~= 426 then
                                    SetBlipSprite(blip, 426)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false)
                                end
                            elseif modelloVeicolo == GetHashKey("rhino") then 
                                if blipSprite ~= 421 then
                                    SetBlipSprite(blip, 421)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, blip, false) 
                                end
                            elseif blipSprite ~= 1 then 
                                SetBlipSprite(blip, 1)
                                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) 
                            end

                            passengers = GetVehicleNumberOfPassengers(veh)
                            if passengers then
                                if not IsVehicleSeatFree(veh, -1) then
                                    passengers = passengers + 1
                                end
                                ShowNumberOnBlip(blip, passengers)
                            else
                                HideNumberOnBlip(blip)
                            end
                        else
                            HideNumberOnBlip(blip)
                            if blipSprite ~= 1 then 
                                SetBlipSprite(blip, 1)
                                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) 
                            end
                        end
                        SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) 
                        SetBlipNameToPlayerName(blip, i) 
                        SetBlipScale(blip, 0.85) 

                        if IsPauseMenuActive() then
                            SetBlipAlpha(blip, 255)
                        else 
                            x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true)) 
                            x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(i), true)) 
                            distanza = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                            if distanza < 0 then
                                distanza = 0
                            elseif distanza > 255 then
                                distanza = 255
                            end
                            SetBlipAlpha(blip, distanza)
                        end
                    end
                else
                    RemoveBlip(blip)
                end
            end
        end
    end
end)