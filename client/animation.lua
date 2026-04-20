-- lcky-auction Client - Animation System

-- ============================================================================
-- ANIMATION
-- ============================================================================

function PlayBidAnimation()
    local ped = cache.ped
    if not ped then return end
    
    lib.playAnim(ped, Config.Animation.dict, Config.Animation.anim,
        8.0, 8.0, Config.Animation.duration, Config.Animation.flags)
end

-- ============================================================================
-- EVENT
-- ============================================================================

RegisterNetEvent('lcky-auction:client:playBidAnimation', function()
    PlayBidAnimation()
end)