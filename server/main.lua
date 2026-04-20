-- lcky-auction Server - Main Event Handlers

-- ============================================================================
-- COMMANDS
-- ============================================================================

RegisterCommand('auction', function(source)
    if source == 0 then return end
    
    if HasActiveAuction() then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = Config.Locale.auctionExists
        })
        return
    end
    
    TriggerClientEvent('lcky-auction:client:openInputDialog', source)
end, false)

-- ============================================================================
-- AUCTION CREATION
-- ============================================================================

RegisterNetEvent('lcky-auction:server:createAuction', function(data)
    local source = source
    
    if HasActiveAuction() then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = Config.Locale.auctionExists
        })
        return
    end
    
    local auctionData = {
        title = data.title,
        description = data.description or '',
        startingPrice = tonumber(data.startingPrice) or Config.Defaults.defaultStartingPrice,
        minIncrement = tonumber(data.minIncrement) or Config.Defaults.defaultMinIncrement,
        duration = tonumber(data.duration) or Config.Defaults.defaultDuration
    }
    
    local success, result = CreateAuction(source, auctionData)
    
    if success then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = Config.Locale.auctionCreated
        })
        
        TriggerClientEvent('lcky-auction:client:createZone', -1, result)
        TriggerClientEvent('lcky-auction:client:enableHostControls', source, result)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = result
        })
    end
end)

-- ============================================================================
-- PARTICIPATION
-- ============================================================================

RegisterNetEvent('lcky-auction:server:joinAuction', function()
    local source = source
    local success, message = JoinAuction(source)
    
    if success then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = message
        })
        TriggerClientEvent('lcky-auction:client:joinedSuccess', source)
        BroadcastToZone('lcky-auction:client:updateAuction', GetAuctionData())
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = message
        })
    end
end)

-- ============================================================================
-- BIDDING
-- ============================================================================

RegisterNetEvent('lcky-auction:server:placeBid', function(amount)
    local source = source
    local bidAmount = tonumber(amount)
    
    local success, message = PlaceBid(source, bidAmount)
    
    if success then
        TriggerClientEvent('lcky-auction:client:playBidAnimation', source)
        
        local auctionData = GetAuctionData()
        BroadcastToZone('lcky-auction:client:updateAuction', auctionData)
        
        local player = GetPlayerFromServerId(source)
        BroadcastToZone('lcky-auction:client:notifyNewBid', {
            bidder = GetPlayerName(player),
            amount = bidAmount
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = message
        })
    end
end)

-- ============================================================================
-- HOST CONTROLS
-- ============================================================================

RegisterNetEvent('lcky-auction:server:advanceStage', function()
    local source = source
    local success, result = AdvanceStage(source)
    
    if success then
        if result.winner then
            BroadcastToZone('lcky-auction:client:auctionSold', result)
            TriggerClientEvent('lcky-auction:client:removeZone', -1)
        else
            BroadcastToZone('lcky-auction:client:stageUpdate', result)
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = result
        })
    end
end)

-- ============================================================================
-- ZONE TRACKING
-- ============================================================================

RegisterNetEvent('lcky-auction:server:enterZone', function()
    AddPlayerToZone(source)
    if HasActiveAuction() then
        TriggerClientEvent('lcky-auction:client:updateAuction', source, GetAuctionData())
    end
end)

RegisterNetEvent('lcky-auction:server:exitZone', function()
    RemovePlayerFromZone(source)
end)

-- ============================================================================
-- BROADCAST HELPER
-- ============================================================================

function BroadcastToZone(eventName, data)
    for serverId, _ in pairs(GetPlayersInZone()) do
        TriggerClientEvent(eventName, serverId, data)
    end
end

-- ============================================================================
-- PLAYER DISCONNECT
-- ============================================================================

AddEventHandler('playerDropped', function()
    local source = source
    RemovePlayerFromZone(source)
    
    if HasActiveAuction() and GetAuctionHost() == source then
        BroadcastToZone('lcky-auction:client:hostDisconnected', {
            title = GetAuctionData().title
        })
        TriggerClientEvent('lcky-auction:client:removeZone', -1)
        EndAuction()
    end
end)