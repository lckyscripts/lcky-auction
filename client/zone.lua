-- lcky-auction Client - Zone Management
-- Uses lib.points for proximity detection

-- ============================================================================
-- LOCAL STATE
-- ============================================================================

local auctionPoint = nil
local lastTimeDisplay = ''

-- ============================================================================
-- ZONE FUNCTIONS
-- ============================================================================

function CreateAuctionZone(coords, radius)
    if auctionPoint then
        auctionPoint:remove()
        auctionPoint = nil
    end
    
    radius = radius or Config.Zone.radius
    
    auctionPoint = lib.points.new({
        coords = coords,
        distance = radius
    })
    
    function auctionPoint:onEnter()
        SetZoneState(true)
        
        lib.notify({
            title = 'Açık Artırma Alanı',
            description = Config.Locale.enterZone,
            type = 'inform'
        })
        
        ShowAuctionTextUI()
        lastTimeDisplay = ''
    end
    
    function auctionPoint:onExit()
        SetZoneState(false)
        lib.hideTextUI()
        lastTimeDisplay = ''
    end
    
    function auctionPoint:nearby()
        local data = GetLocalAuctionData()
        if data then
            local timeRemaining = math.max(0, data.endTime - os.time())
            local timeDisplay = FormatTime(timeRemaining)
            
            if timeDisplay ~= lastTimeDisplay then
                lastTimeDisplay = timeDisplay
                UpdateTextUI()
            end
            
            if Config.Zone.showMarker then
                DrawMarker(Config.Zone.markerType, self.coords.x, self.coords.y, self.coords.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0,
                    Config.Zone.markerColor.r, Config.Zone.markerColor.g, Config.Zone.markerColor.b, Config.Zone.markerColor.a,
                    false, true, 2, false, nil, nil, false)
            end
        end
    end
end

function RemoveAuctionZone()
    if auctionPoint then
        auctionPoint:remove()
        auctionPoint = nil
    end
    lib.hideTextUI()
    lastTimeDisplay = ''
end