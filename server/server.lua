ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('quitarDinero')
AddEventHandler('quitarDinero', function()
    local Source = source

    local xPlayer = ESX.GetPlayerFromId(Source)
    local item = xPlayer.getInventoryItem("money")
    
    xPlayer.removeInventoryItem("money", Config.Amount)
    TriggerClientEvent('esx:showNotification', source, "El vehículo ha sido lavado por <span style='color:#47cf73'>$"..tonumber(Config.Amount).."</span> Gracias por visitarnos", 8000, 'success')
end)