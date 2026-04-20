-- lcky-auction Server - Auction State Management
-- RAM-based auction logic

-- ============================================================================
-- STATE VARIABLES
-- ============================================================================

local AuctionData = nil
local PlayersInZone = {}
local Participants = {}

-- ============================================================================
-- AUCTION FUNCTIONS
-- ============================================================================

function CreateAuction(hostServerId, data)
    if AuctionData and AuctionData.isActive then
        return false, Config.Locale.auctionExists
    end
    
    -- Get host coordinates
    local player = GetPlayerFromServerId(hostServerId)
    if not player then return false, 'Player not found' end
    
    local ped = GetPlayerPed(player)
    if not ped then return false, 'Ped not found' end
    
    local coords = GetEntityCoords(ped)
    
    AuctionData = {
        id = GenerateAuctionId(),
        title = data.title,
        description = data.description or '',
        startingPrice = data.startingPrice,
        minIncrement = data.minIncrement,
        hostServerId = hostServerId,
        hostName = GetPlayerName(player),
        isActive = true,
        stage = 0,
        currentBid = data.startingPrice,
        highestBidder = nil,
        duration = data.duration,
        startTime = os.time(),
        endTime = os.time() + data.duration,
        coords = vector3(coords.x, coords.y, coords.z),
        radius = Config.Zone.radius,
        participants = {}
    }
    
    -- Host automatically joins
    Participants[hostServerId] = true
    AuctionData.participants[hostServerId] = {
        name = AuctionData.hostName
    }
    
    PlayersInZone = {}
    
    return true, AuctionData
end

function JoinAuction(serverId)
    if not AuctionData or not AuctionData.isActive then
        return false, Config.Locale.noActiveAuction
    end
    
    if Participants[serverId] then
        return false, Config.Locale.alreadyJoined
    end
    
    local player = GetPlayerFromServerId(serverId)
    Participants[serverId] = true
    AuctionData.participants[serverId] = {
        name = GetPlayerName(player)
    }
    
    return true, Config.Locale.joinedAuction
end

function PlaceBid(serverId, amount)
    if not AuctionData or not AuctionData.isActive then
        return false, Config.Locale.noActiveAuction
    end
    
    if not Participants[serverId] then
        return false, Config.Locale.notParticipant
    end
    
    if AuctionData.stage > 0 then
        return false, Config.Locale.auctionEnding
    end
    
    local minBid = AuctionData.currentBid + AuctionData.minIncrement
    if amount < minBid then
        return false, string.format(Config.Locale.minBidRequired, FormatMoney(minBid))
    end
    
    local player = GetPlayerFromServerId(serverId)
    AuctionData.currentBid = amount
    AuctionData.highestBidder = {
        serverId = serverId,
        name = GetPlayerName(player)
    }
    
    return true, Config.Locale.bidPlaced
end

function AdvanceStage(serverId)
    if not AuctionData or not AuctionData.isActive then
        return false, Config.Locale.noActiveAuction
    end
    
    if AuctionData.hostServerId ~= serverId then
        return false, Config.Locale.hostOnly
    end
    
    AuctionData.stage = AuctionData.stage + 1
    
    if AuctionData.stage >= 3 then
        local winner = AuctionData.highestBidder
        local amount = AuctionData.currentBid
        local title = AuctionData.title
        
        AuctionData = nil
        Participants = {}
        PlayersInZone = {}
        
        return true, { winner = winner, amount = amount, title = title }
    end
    
    local stageMessages = { [1] = Config.Locale.stageOne, [2] = Config.Locale.stageTwo }
    return true, { stage = AuctionData.stage, message = stageMessages[AuctionData.stage] }
end

function EndAuction()
    local winner = AuctionData and AuctionData.highestBidder
    local amount = AuctionData and AuctionData.currentBid
    local title = AuctionData and AuctionData.title
    
    AuctionData = nil
    Participants = {}
    PlayersInZone = {}
    
    return { winner = winner, amount = amount, title = title }
end

-- ============================================================================
-- ZONE FUNCTIONS
-- ============================================================================

function AddPlayerToZone(serverId)
    PlayersInZone[serverId] = true
end

function RemovePlayerFromZone(serverId)
    PlayersInZone[serverId] = nil
end

function GetPlayersInZone()
    return PlayersInZone
end

function GetAuctionData()
    if not AuctionData then return nil end
    
    local data = {}
    for k, v in pairs(AuctionData) do
        data[k] = v
    end
    data.timeRemaining = math.max(0, AuctionData.endTime - os.time())
    
    return data
end

function HasActiveAuction()
    return AuctionData and AuctionData.isActive
end

function GetAuctionHost()
    return AuctionData and AuctionData.hostServerId
end

function IsParticipant(serverId)
    return Participants[serverId] == true
end