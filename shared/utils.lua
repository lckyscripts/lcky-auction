-- lcky-auction Utility Functions
-- Minimal shared utilities

--- Format a number as currency with thousand separators
function FormatMoney(amount)
    if not amount then return '0' end
    local formatted = tostring(math.floor(amount))
    formatted = formatted:reverse():gsub('(%d%d%d)', '%1,')
    formatted = formatted:reverse()
    return formatted:gsub('^,', '')
end

--- Format seconds into MM:SS format
function FormatTime(seconds)
    if not seconds or seconds < 0 then seconds = 0 end
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format('%02d:%02d', mins, secs)
end

--- Generate unique auction ID
local auctionIdCounter = 0
function GenerateAuctionId()
    auctionIdCounter = auctionIdCounter + 1
    return auctionIdCounter
end