-- lcky-auction Configuration
-- Framework independent, ox_lib required

Config = Config or {}

-- ============================================================================
-- ZONE SETTINGS
-- ============================================================================

Config.Zone = {
    -- Zone radius in meters
    radius = 20.0,
    
    -- Optional: Show a marker at zone center (set to false to disable)
    showMarker = false,
    markerType = 1,
    markerColor = { r = 255, g = 215, b = 0, a = 100 }  -- Gold color
}

-- ============================================================================
-- KEYBIND SETTINGS
-- ============================================================================

Config.Keybinds = {
    -- Join auction / Place bid key (default: X)
    -- This key is used for both joining and bidding
    joinBid = {
        name = 'lcky_auction_join_bid',
        description = 'Join the Auction / Bid',
        defaultKey = 'X'
    },
    
    -- Host control keys (3-stage auction control)
    hostControls = {
        -- Stage 1: "Going Once"
        stage1 = {
            name = 'lcky_auction_stage1',
            description = 'Auction - Stage One!',
            defaultKey = 'F5'
        },
        -- Stage 2: "Going Twice"
        stage2 = {
            name = 'lcky_auction_stage2',
            description = 'Auction - Stage Two!',
            defaultKey = 'F6'
        },
        -- Stage 3: "SOLD"
        stage3 = {
            name = 'lcky_auction_stage3',
            description = 'Auction - Sold!',
            defaultKey = 'F7'
        }
    }
}

-- ============================================================================
-- ANIMATION SETTINGS
-- ============================================================================

Config.Animation = {
    -- Hand raise animation dictionary and name
    dict = 'missminuteman_1ig_2',
    anim = 'handsup_base',
    
    -- Animation duration in milliseconds
    duration = 2000,
    
    -- Animation flags (49 = allow movement + upper body only)
    flags = 49
}

-- ============================================================================
-- UI SETTINGS
-- ============================================================================

Config.UI = {
    -- TextUI position
    textUIPosition = 'right-center',
    
    -- Notification position
    notifyPosition = 'top',
    
    -- TextUI refresh interval (ms) - for time display updates
    -- Lower = more accurate but more updates
    refreshInterval = 1000
}

-- ============================================================================
-- DEFAULT VALUES
-- ============================================================================

Config.Defaults = {
    -- Auction duration limits (in seconds)
    minDuration = 30,
    maxDuration = 600,  -- 10 minutes
    
    -- Price limits
    minStartingPrice = 1,
    minIncrement = 1,
    
    -- Default values for input dialog
    defaultStartingPrice = 100,
    defaultMinIncrement = 10,
    defaultDuration = 120  -- 2 minutes
}

-- ============================================================================
-- NOTIFICATION SETTINGS
-- ============================================================================

Config.Notifications = {
    -- Duration for various notification types (ms)
    durations = {
        error = 4500,
        success = 4500,
        inform = 4500,
        warning = 4500
    }
}

-- ============================================================================
-- LOCALE (Turkish)
-- ============================================================================

Config.Locale = {
    -- Auction creation
    auctionCreated = 'Auction created!',
    auctionExists = 'An auction already exists!',
    titleRequired = 'Title required!',
    
    -- Participation
    joinedAuction = 'Joined to Auction!',
    alreadyJoined = 'Already joined to Auction!',
    noActiveAuction = 'There\'s no active auction.',
    
    -- Bidding
    bidPlaced = 'Bid placed!',
    minBidRequired = 'Min bid: $%s',
    notParticipant = 'You\'re not a participant!',
    auctionEnding = 'Auction is ending!',
    
    -- Host controls
    hostOnly = 'There could be one host!',
    stageOne = 'Stage ONE!',
    stageTwo = 'STAGE TWO!',
    sold = 'SOLD!',
    noWinner = 'There\'s no winner!',
    
    -- Zone
    enterZone = 'Press X to join the Auction.',
    newBid = 'New Bid!',
    
    -- Input dialog
    inputTitle = 'Auction Creation',
    inputTitleLabel = 'Title',
    inputDescLabel = 'Description',
    inputStartPriceLabel = 'Start Price',
    inputMinIncrementLabel = 'Min Increment',
    inputDurationLabel = 'Time (seconds)',
    
    -- Bid dialog
    bidDialogTitle = 'Bid',
    bidAmountLabel = 'Bid Amount'
}
