-- lcky-auction Client - Keybind System

-- ============================================================================
-- LOCAL STATE
-- ============================================================================

local joinBidKeybind = nil
local hostKeybinds = { stage1 = nil, stage2 = nil, stage3 = nil }
local hostKeybindsActive = false

-- ============================================================================
-- JOIN/BID KEYBIND (X)
-- ============================================================================

CreateThread(function()
    joinBidKeybind = lib.addKeybind({
        name = Config.Keybinds.joinBid.name,
        description = Config.Keybinds.joinBid.description,
        defaultKey = Config.Keybinds.joinBid.defaultKey,
        onPressed = function()
            if not IsPlayerInAuctionZone() then return end
            local data = GetLocalAuctionData()
            if not data then return end
            
            if not HasPlayerJoined() then
                TriggerServerEvent('lcky-auction:server:joinAuction')
            else
                OpenBidDialog()
            end
        end
    })
end)

-- ============================================================================
-- HOST KEYBINDS (F5, F6, F7)
-- ============================================================================

function InitializeHostKeybinds()
    if hostKeybindsActive then return end
    
    hostKeybinds.stage1 = lib.addKeybind({
        name = Config.Keybinds.hostControls.stage1.name,
        description = Config.Keybinds.hostControls.stage1.description,
        defaultKey = Config.Keybinds.hostControls.stage1.defaultKey,
        onPressed = function()
            if not IsPlayerHost() then return end
            local data = GetLocalAuctionData()
            if data and data.stage == 0 then
                TriggerServerEvent('lcky-auction:server:advanceStage')
            end
        end
    })
    
    hostKeybinds.stage2 = lib.addKeybind({
        name = Config.Keybinds.hostControls.stage2.name,
        description = Config.Keybinds.hostControls.stage2.description,
        defaultKey = Config.Keybinds.hostControls.stage2.defaultKey,
        onPressed = function()
            if not IsPlayerHost() then return end
            local data = GetLocalAuctionData()
            if data and data.stage == 1 then
                TriggerServerEvent('lcky-auction:server:advanceStage')
            end
        end
    })
    
    hostKeybinds.stage3 = lib.addKeybind({
        name = Config.Keybinds.hostControls.stage3.name,
        description = Config.Keybinds.hostControls.stage3.description,
        defaultKey = Config.Keybinds.hostControls.stage3.defaultKey,
        onPressed = function()
            if not IsPlayerHost() then return end
            local data = GetLocalAuctionData()
            if data and data.stage == 2 then
                TriggerServerEvent('lcky-auction:server:advanceStage')
            end
        end
    })
    
    hostKeybindsActive = true
end

function DisableHostKeybinds()
    if not hostKeybindsActive then return end
    
    if hostKeybinds.stage1 then hostKeybinds.stage1:disable(true) end
    if hostKeybinds.stage2 then hostKeybinds.stage2:disable(true) end
    if hostKeybinds.stage3 then hostKeybinds.stage3:disable(true) end
    
    hostKeybindsActive = false
end