local RSGCore = exports['rsg-core']:GetCoreObject()
local PlayerData = RSGCore.Functions.GetPlayerData()

local ped
local remainingTickets = CONFIG.MaxTickets

function ticketAmount()
    local cid = PlayerData.citizenid
    local amount = exports['rsg-input']:ShowInput({
        header = 'Amount of Tickets',
        inputs = {
            {
                text = 'Max' .. CONFIG.MaxTickets .. ' Tickets',
                name = 'amount',
                type = 'number',
                default = 1
            }
        }
    })

    if CONFIG.MaxTickets == 0 then
        TriggerServerEvent('jp-lotto:server:buylotto', amount.amount, cid)
    else
        if tonumber(amount.amount) > remainingTickets then
            RSGCore.Functions.Notify('You can\'t buy more than ' .. remainingTickets .. ' more!', 'error', 2000)
            print('Tickets Remaining: ' .. remainingTickets)
        else
            TriggerServerEvent('jp-lotto:server:buylotto', amount.amount, cid)
            remainingTickets = remainingTickets - tonumber(amount.amount)
            print('Tickets Remaining: ' .. remainingTickets)
        end
    end
end

RegisterNetEvent('jp-lotto:client:useticket')
AddEventHandler('jp-lotto:client:useticket', function()
    local chance = math.random(1, 100)
    local amount = 0

    if chance == CONFIG.HighAwardChance then
        RSGCore.Functions.Notify('You won the entire pool!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'all')
    elseif chance > CONFIG.HighAwardChance and chance <= CONFIG.MediumAwardChance then
        RSGCore.Functions.Notify('You won money from the lottery!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'medium')
    elseif chance > CONFIG.MediumAwardChance and chance <= CONFIG.LowAward then -- Changed the logical operator to 'and'
        RSGCore.Functions.Notify('You won money from the lottery!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'low')
    elseif chance > 20 then
        RSGCore.Functions.Notify('You didn\'t win anything!', 'error', 2000)
    else
        RSGCore.Functions.Notify('You didn\'t win anything!', 'error', 2000)
    end
end)
