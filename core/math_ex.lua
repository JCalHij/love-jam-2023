--[[
Returns the value `value` clamped between range [`min`, `max`].
]]
---@param value number
---@param min number
---@param max number
---@return number
function math.clamp(value, min, max)
    return math.max(min, math.min(value, max))
end