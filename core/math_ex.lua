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

--[[
Returns the rounded value for `value`.

TODO[javi]: Maybe this in the future? https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
]]
---@param value number
---@return integer
function math.round(value)
    return math.floor(value + 0.5)
end