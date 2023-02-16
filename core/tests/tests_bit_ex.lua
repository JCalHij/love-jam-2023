---@class BitExTestSuite: TestSuite
---@operator call(): BitExTestSuite
BitExTestSuite = TestSuite:extend()

function BitExTestSuite:new()
    BitExTestSuite.super.new(self, "bit_ex")
end

function BitExTestSuite:test_bit_check()
    local value = 7  -- == 0b0111
    assert(bit.check(value, 0x02) == true,  "0x02 == 0b0010")
    assert(bit.check(value, 0x05) == true,  "0x05 == 0b0101")
    assert(bit.check(value, 0x09) == false, "0x09 == 0b1001")
end