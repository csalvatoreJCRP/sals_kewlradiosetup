-- server.lua

local QBCore = exports['qb-core']:GetCoreObject()

-- Register a callback to get player radio data
QBCore.Functions.CreateCallback('radio:getData', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local radioID = Player.PlayerData.metadata["radio_id"] or ""
        local codePlug = Player.PlayerData.metadata["code_plug"] or ""
        cb({ radioID = radioID, codePlug = codePlug })
    else
        cb(nil)
    end
end)

-- Register an event to set Radio ID
RegisterNetEvent('radio:setRadioID', function(radioID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData("radio_id", radioID)
        TriggerClientEvent('QBCore:Notify', src, 'Radio ID set to ' .. radioID, 'success')
    end
end)

-- Register an event to set CodePlug
RegisterNetEvent('radio:setCodePlug', function(codePlug)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData("code_plug", codePlug)
        TriggerClientEvent('QBCore:Notify', src, 'CodePlug set to ' .. codePlug, 'success')
    end
end)
