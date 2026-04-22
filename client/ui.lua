-- lcky-auction Client - UI Management

-- ============================================================================
-- TEXTUI FUNCTIONS
-- ============================================================================

function ShowAuctionTextUI()
    local data = GetLocalAuctionData()
    if not data then return end
    
    lib.showTextUI(BuildAuctionText(), { position = Config.UI.textUIPosition })
end

function UpdateTextUI()
    local data = GetLocalAuctionData()
    if not data or not IsPlayerInAuctionZone() then return end
    
    lib.showTextUI(BuildAuctionText(), { position = Config.UI.textUIPosition })
end

-- ============================================================================
-- TEXT builder
-- ============================================================================

function BuildAuctionText()
    local data = GetLocalAuctionData()
    if not data then return '' end
    
    local timeRemaining = math.max(0, data.endTime - GetCloudTimeAsInt())
    local highestBidder = 'There\'s no bid yet'
    if data.highestBidder and data.highestBidder.name then
        highestBidder = data.highestBidder.name
    end
    
    local stageText = ''
    if data.stage == 1 then
        stageText = '\n\n⚠️ **' .. Config.Locale.stageOne .. '**'
    elseif data.stage == 2 then
        stageText = '\n\n⚠️⚠️ **' .. Config.Locale.stageTwo .. '**'
    end
    
    local actionHint = ''
    if not HasPlayerJoined() then
        actionHint = '  \n**Join Auction: [X] **'
    else
        local minBid = data.currentBid + data.minIncrement
        actionHint = '  \n**[X] Bid ($' .. FormatMoney(minBid) .. '+)**'
    end
    
    return string.format(
        '**%s**  \n%s  \n💰 **Current Bid:** $%s  \n👤 **Highest:** %s  \n⏱️ **Remain:** %s%s%s',
        data.title,
        data.description ~= '' and data.description or '',
        FormatMoney(data.currentBid),
        highestBidder,
        FormatTime(timeRemaining),
        stageText,
        actionHint
    )
end

-- ============================================================================
-- BID DIALOG
-- ============================================================================

function OpenBidDialog()
    local data = GetLocalAuctionData()
    if not data then return end
    
    local minBid = data.currentBid + data.minIncrement
    
    local input = lib.inputDialog(Config.Locale.bidDialogTitle, {
        { type = 'number', label = Config.Locale.bidAmountLabel, default = minBid, min = minBid }
    })
    
    if not input then return end
    
    local bidAmount = tonumber(input[1])
    if bidAmount and bidAmount >= minBid then
        TriggerServerEvent('lcky-auction:server:placeBid', bidAmount)
    end
end
