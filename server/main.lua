local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('jp-lotto:server:buylotto')
AddEventHandler('jp-lotto:server:buylotto', function(amount, cid)
    local Player = RSGCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local charname = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    local price = CONFIG.TicketPrice * amount

    Player.Functions.AddItem('lottoticket', amount)
    Player.Functions.RemoveMoney('cash', price)
    TriggerClientEvent('inventory:client:ItemBox', source, RSGCore.Shared.Items['lottoticket'], 'add')

    MySQL.update('UPDATE lotto SET pool = pool + ?', {
        price
    }, function(affectedRows)
        print(affectedRows)
    end)

    local webhookUrl = CONFIG.Webhook
    local discordMessage = string.format('**Logs**\nPlayer: %s\nCitizen ID: %s\nBought %s', charname, citizenid, amount .. ' Lotto Tickets')
    local discordPayload = {
        embeds = {
            {
                title = 'Lotto Logs',
                description = discordMessage,
                color = 16711680 -- Red color in decimal format
            }
        }
    }
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(discordPayload), { ['Content-Type'] = 'application/json' })
end)

RSGCore.Functions.CreateUseableItem('lottoticket', function(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('lottoticket', 1)

    TriggerClientEvent('jp-lotto:client:useticket', source)
end)

RegisterServerEvent('jp-lotto:server:givemoney')
AddEventHandler('jp-lotto:server:givemoney', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(source)
    local pool = 0

    if amount == 'all' then
        local award = CONFIG.HighAward

        if award == 0 then
            MySQL.query('SELECT `pool` FROM `lotto`', {}, function(response)
                if response then
                    for i = 1, #response do
                        local row = response[i]
                        local poolAmount = row.pool

                        MySQL.update('UPDATE lotto SET pool = ?', {
                            0,
                        }, function(affectedRows)
                            Player.Functions.AddMoney('cash', poolAmount)
                        end)
                    end
                end
            end)
        elseif award > 0 then
            MySQL.query('SELECT `pool` FROM `lotto`', {}, function(response)
                if response then
                    for i = 1, #response do
                        local row = response[i]
                        local poolAmount = row.pool
    
                        if poolAmount >= award then
                            poolAmount = poolAmount - award
                            MySQL.update('UPDATE lotto SET pool = pool - ?', {
                                poolAmount,
                            }, function(affectedRows)
                                Player.Functions.AddMoney('cash', award)
                            end)
                        else
                            MySQL.update('UPDATE lotto SET pool = ?', {
                                0,
                            }, function(affectedRows)
                                RSGCore.Functions.Notify(src, 'There wasn\'t enough money, so you got what was in the pool!', 'success', 3000)
                                Player.Functions.AddMoney('cash', poolAmount)
                            end)
                        end
                    end
                end
            end)
        end

        local webhookUrl = CONFIG.Webhook
        local discordMessage = string.format('**Logs**\nTag: %s\nPlayer: %s\nCitizen ID: %s\nJUST WON the pool!!!!! %s', '@everyone', charname, citizenid, pool)
        local discordPayload = {
            embeds = {
                {
                    title = 'Lotto Logs',
                    description = discordMessage,
                    color = 16711680 -- Red color in decimal format
                }
            }
        }
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(discordPayload), { ['Content-Type'] = 'application/json' })
    elseif amount == 'medium' then
        local award = CONFIG.MediumAward
        MySQL.query('SELECT `pool` FROM `lotto`', {}, function(response)
            if response then
                for i = 1, #response do
                    local row = response[i]
                    local poolAmount = row.pool

                    if poolAmount >= award then
                        poolAmount = poolAmount - award
                        MySQL.update('UPDATE lotto SET pool = pool - ?', {
                            poolAmount,
                        }, function(affectedRows)
                            Player.Functions.AddMoney('cash', award)
                        end)
                    else
                        MySQL.update('UPDATE lotto SET pool = ?', {
                            0,
                        }, function(affectedRows)
                            RSGCore.Functions.Notify(src, 'There wasn\'t enough money, so you got what was in the pool!', 'success', 3000)
                            Player.Functions.AddMoney('cash', poolAmount)
                        end)
                    end
                end
            end
        end)

        local webhookUrl = CONFIG.Webhook
        local discordMessage = string.format('**Logs**\nTag: %s\nPlayer: %s\nCitizen ID: %s\nJust won: $ %s', charname, citizenid, award)
        local discordPayload = {
            embeds = {
                {
                    title = 'Lotto Logs',
                    description = discordMessage,
                    color = 16711680 -- Red color in decimal format
                }
            }
        }
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(discordPayload), { ['Content-Type'] = 'application/json' })
    elseif amount == 'low' then
        local award = CONFIG.LowAward

        MySQL.query('SELECT `pool` FROM `lotto`', {}, function(response)
            if response then
                for i = 1, #response do
                    local row = response[i]
                    local poolAmount = row.pool

                    if poolAmount >= award then
                        poolAmount = poolAmount - award
                        MySQL.update('UPDATE lotto SET pool = pool - ?', {
                            award,
                        }, function(affectedRows)
                            Player.Functions.AddMoney('cash', award)
                        end)
                    else
                        MySQL.update('UPDATE lotto SET pool = ?', {
                            0,
                        }, function(affectedRows)
                            RSGCore.Functions.Notify(src, 'There wasn\'t enough money, so you got what was in the pool!', 'success', 3000)
                            Player.Functions.AddMoney('cash', poolAmount)
                        end)
                    end
                end
            end
        end)

        local webhookUrl = CONFIG.Webhook
        local discordMessage = string.format('**Logs**\nTag: %s\nPlayer: %s\nCitizen ID: %s\nJust won: $ %s', charname, citizenid, award)
        local discordPayload = {
            embeds = {
                {
                    title = 'Lotto Logs',
                    description = discordMessage,
                    color = 16711680 -- Red color in decimal format
                }
            }
        }
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(discordPayload), { ['Content-Type'] = 'application/json' })
    end
end)
