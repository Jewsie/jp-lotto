local RSGCore = exports['rsg-core']:GetCoreObject()
local PlayerData = RSGCore.Functions.GetPlayerData()

local ped
local remainingTickets = 5

function ticketAmount()
    local cid = PlayerData.citizenid
    local amount = exports['rsg-input']:ShowInput({
        header = 'Amount of Tickets',
        inputs = {
            {
                text = 'Max 5 Tickets',
                name = 'amount',
                type = 'number',
                default = 1
            }
        }
    })

    if tonumber(amount.amount) > remainingTickets then
        RSGCore.Functions.Notify('You can\'t buy more than ' .. remainingTickets .. ' more!', 'error', 2000)
        print('Tickets Remaining: ' .. remainingTickets)
    else
        TriggerServerEvent('jp-lotto:server:buylotto', amount.amount, cid)
        remainingTickets = remainingTickets - tonumber(amount.amount)
        print('Tickets Remaining: ' .. remainingTickets)
    end
end

RegisterNetEvent('jp-lotto:client:useticket')
AddEventHandler('jp-lotto:client:useticket', function()
    local chance = math.random(1, 100)
    local amount = 0

    if chance == 1 then
        RSGCore.Functions.Notify('You won the entire pool!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'all')
    elseif chance > 1 and chance <= 5 then
        RSGCore.Functions.Notify('You won money from the lottery!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'medium')
    elseif chance > 5 and chance <= 20 then -- Changed the logical operator to 'and'
        amount = math.random(1, 2)
        RSGCore.Functions.Notify('You won money from the lottery!', 'success', 2000)
        TriggerServerEvent('jp-lotto:server:givemoney', 'low')
    elseif chance > 20 then
        RSGCore.Functions.Notify('You didn\'t win anything!', 'error', 2000)
    else
        RSGCore.Functions.Notify('You didn\'t win anything!', 'error', 2000)
    end
end)