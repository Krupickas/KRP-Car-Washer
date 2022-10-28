ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
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



RegisterNetEvent('wash:car', function()
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = ESX.Game.GetClosestVehicle()
                local cardist =    GetEntityCoords(vehicle)
            local dist = #(coords - cardist)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification('You cant be in vehicle')
                return
            end

            if dist < 3.5 then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
                local success = lib.progressBar({
                    duration = 10000,
                    label = 'Your vehicle is being cleaned',
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

                    ESX.ShowNotification('Vehicle has been cleaned')
                    isBusy = false
                end)
            else
                ESX.ShowNotification('No vehicle nearby')
            end

  end)




AddEventHandler('wash:car', function(data)
	print(data.label, data.num, data.entity)
end)

exports.qtarget:AddTargetModel({262335250}, {
	options = {
		{
			event = "wash:car",
			icon = "fas fa-hands-bubbles",
			label = "Wash",
			num = 1
		},
	},
	distance = 2
})