ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerLoaded = true
    ESX.PlayerData = ESX.GetPlayerData()

end)

Citizen.CreateThread(function()
    for i=1, #Config.Blips, 1 do
        local Blip = Config.Blips[i]
        blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
        SetBlipSprite(blip, Blip["id"])
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Blip["scale"])
        SetBlipColour(blip, Blip["color"])
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Blip["text"])
        EndTextCommandSetBlipName(blip)
    end
end)  



RegisterNetEvent('lavar:auto', function()
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = ESX.Game.GetClosestVehicle()
                local cardist =    GetEntityCoords(vehicle)
            local dist = #(coords - cardist)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification('No puedes estar en el vehículo')--
                return
            end

            if dist < 3.5 then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
                local success = lib.progressBar({
                    duration = Config.Duration,
                    label = 'Se está lavando su vehículo',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                })
                Citizen.CreateThread(function()
                    Citizen.Wait(50)

                    SetVehicleDirtLevel(vehicle, 0)
                    ClearPedTasksImmediately(playerPed)
                    TriggerServerEvent('quitarDinero', dist)
                    isBusy = false
                end)
            else
                ESX.ShowNotification('No hay vehículo cerca')
            end

  end)




AddEventHandler('lavar:auto', function(data)
	print(data.label, data.num, data.entity)
end)

exports.qtarget:AddTargetModel({262335250}, {
	options = {
		{
			event = "lavar:auto",
			icon = "fas fa-hands-bubbles",
			label = "Lavar vehiculo",
			num = 1
		},
	},
	distance = 2
})