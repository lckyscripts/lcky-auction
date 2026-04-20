-- lcky-auction Client - Main Event Handlers

-- ============================================================================
-- LOCAL STATE
-- ============================================================================

local auctionData = nil
local isInZone = false
local isHost = false
local hasJoined = false

-- ============================================================================
-- INPUT DIALOG
-- ============================================================================

RegisterNetEvent('lcky-auction:client:openInputDialog', function()
    local input = lib.inputDialog(Config.Locale.inputTitle, {
        { type = 'input', label = Config.Locale.inputTitleLabel, required = true },
        { type = 'textarea', label = Config.Locale.inputDescLabel, required = false },
        { type = 'number', label = Config.Locale.inputStartPriceLabel, default = Config.Defaults.defaultStartingPrice },
        { type = 'number', label = Config.Locale.inputMinIncrementLabel, default = Config.Defaults.defaultMinIncrement },
        { type = 'number', label = Config.Locale.inputDurationLabel, default = Config.Defaults.defaultDuration, min = Config.Defaults.minDuration, max = Config.Defaults.maxDuration }
    })
    
    if not input then return end
    
    TriggerServerEvent('lcky-auction:server:createAuction', {
        title = input[1],
        description = input[2] or '',
        startingPrice = input[3],
        minIncrement = input[4],
        duration = input[5]
    })
end)

-- ============================================================================
-- AUCTION EVENTS
-- ============================================================================

RegisterNetEvent('lcky-auction:client:createZone', function(data)
    auctionData = data
    CreateAuctionZone(data.coords, data.radius)
end)

RegisterNetEvent('lcky-auction:client:enableHostControls', function(data)
    isHost = true
    hasJoined = true
    InitializeHostKeybinds()
    
    lib.notify({
        title = 'Host Kontrolleri',
        description = 'F5: Bir Kez | F6: İki Kez | F7: SATILDI',
        type = 'inform',
        duration = 5000
    })
end)

RegisterNetEvent('lcky-auction:client:joinedSuccess', function()
    hasJoined = true
    if isInZone then UpdateTextUI() end
end)

RegisterNetEvent('lcky-auction:client:updateAuction', function(data)
    auctionData = data
    if isInZone then UpdateTextUI() end
end)

RegisterNetEvent('lcky-auction:client:notifyNewBid', function(data)
    lib.notify({
        title = Config.Locale.newBid,
        description = data.bidder .. ' - $' .. FormatMoney(data.amount),
        type = 'inform',
        duration = Config.Notifications.durations.inform
    })
end)

RegisterNetEvent('lcky-auction:client:stageUpdate', function(data)
    lib.notify({
        title = auctionData and auctionData.title or 'Açık Artırma',
        description = data.message,
        type = 'warning',
        duration = Config.Notifications.durations.warning
    })
    if isInZone then UpdateTextUI() end
end)

RegisterNetEvent('lcky-auction:client:auctionSold', function(data)
    lib.hideTextUI()
    
    if data and data.winner then
        lib.notify({
            title = Config.Locale.sold,
            description = data.winner.name .. ' kazandı! - $' .. FormatMoney(data.amount),
            type = 'success',
            duration = 6000
        })
    else
        lib.notify({
            title = 'Açık Artırma Sona Erdi',
            description = Config.Locale.noWinner,
            type = 'inform'
        })
    end
    
    ClearAuctionState()
end)

RegisterNetEvent('lcky-auction:client:hostDisconnected', function(data)
    lib.hideTextUI()
    lib.notify({
        title = 'Açık Artırma Sonlandı',
        description = 'Host oyundan çıktı',
        type = 'error'
    })
    ClearAuctionState()
end)

RegisterNetEvent('lcky-auction:client:removeZone', function()
    RemoveAuctionZone()
    ClearAuctionState()
end)

-- ============================================================================
-- STATE FUNCTIONS
-- ============================================================================

function ClearAuctionState()
    auctionData = nil
    isInZone = false
    isHost = false
    hasJoined = false
    DisableHostKeybinds()
end

function GetLocalAuctionData()
    return auctionData
end

function IsPlayerInAuctionZone()
    return isInZone
end

function IsPlayerHost()
    return isHost
end

function HasPlayerJoined()
    return hasJoined
end

function SetZoneState(state)
    isInZone = state
    if state then
        TriggerServerEvent('lcky-auction:server:enterZone')
    else
        TriggerServerEvent('lcky-auction:server:exitZone')
        lib.hideTextUI()
    end
end