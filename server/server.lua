local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('baTu-patlican:toplaPatlican', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.ox_inventory:AddItem(src, 'patlican', 1)
    TriggerClientEvent('QBCore:Notify', src, "1 adet patlıcan topladın!", "success")
end)

RegisterNetEvent('baTu-patlican:islePatlican', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if exports.ox_inventory:Search(src, 'count', 'patlican') >= 1 then
        exports.ox_inventory:RemoveItem(src, 'patlican', 1)
        exports.ox_inventory:AddItem(src, 'islenmis_patlican', 1)
        TriggerClientEvent('QBCore:Notify', src, "1 adet işlenmiş patlıcan aldın!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Patlıcanın yok!", "error")
    end
end)

RegisterNetEvent('baTu-patlican:satPatlican')
AddEventHandler('baTu-patlican:satPatlican', function(patlicanAdet)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local patlicanItem = "islenmis_patlican"
    
    if exports.ox_inventory:Search(src, 'count', patlicanItem) >= patlicanAdet then
        exports.ox_inventory:RemoveItem(src, patlicanItem, patlicanAdet)
        local totalPrice = patlicanAdet * baTu.PatlicanFiyat
        Player.Functions.AddMoney('cash', totalPrice)
        TriggerClientEvent('QBCore:Notify', src, patlicanAdet .. " adet patlıcan sattın. Kazanç: $" .. totalPrice, "success")
        TriggerEvent('baTu-discord:logPatlicanSatis', Player.PlayerData.name, patlicanAdet, totalPrice)
    else
        TriggerClientEvent('QBCore:Notify', src, "Yeterince patlıcanın yok!", "error")
    end
end)

RegisterNetEvent('baTu-discord:logPatlicanSatis')
AddEventHandler('baTu-discord:logPatlicanSatis', function(playerName, patlicanAdet, totalPrice)
    local message = {
        {
            ["color"] = 3066993,
            ["title"] = "Patlıcan Satışı",
            ["description"] = playerName .. " " .. patlicanAdet .. " adet patlıcan sattı. Kazanç: $" .. totalPrice,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }

    PerformHttpRequest(baTu.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Patlıcan Bot", embeds = message}), { ['Content-Type'] = 'application/json' })
end)


