--[[
Extension for LuaJIT's bit module
]]
require "bit" -- LuaJIT's bit32 library

--[[
Checks if given `bitmask` is active on given
`number`.

Example:

    local value = 7  -- == 0b0111
    bit.check(value, 0x02) == true  -- 0x02 == 0b0010
    bit.check(value, 0x05) == true  -- 0x05 == 0b0101
    bit.check(value, 0x09) == false -- 0x09 == 0b1001
]]
---@param number number number to test
---@param mask number the mask to check against the number
---@return boolean
bit.check = function(number, mask)
    return bit.band(number, mask) == mask
end