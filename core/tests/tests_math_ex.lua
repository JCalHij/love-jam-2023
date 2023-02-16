---@class MathExTestSuite: TestSuite
---@operator call(): MathExTestSuite
MathExTestSuite = TestSuite:extend()

function MathExTestSuite:new()
    MathExTestSuite.super.new(self, "math_ex")
end

function MathExTestSuite:test_clamp_in_range()
    local min, max = 0, 10
    local value = 5
    assert(math.clamp(value, min, max) == value, string.format("math.clamp(%d, %d, %d) should return %d. Range is [%d, %d]", value, min, max, value, min, max))
end

function MathExTestSuite:test_clamp_lower_bound()
    local min, max = 0, 10
    local value = -10
    assert(math.clamp(value, min, max) == min, string.format("math.clamp(%d, %d, %d) should return %d. Range is [%d, %d]", value, min, max, min, min, max))
end

function MathExTestSuite:test_clamp_upper_bound()
    local min, max = 0, 10
    local value = 50
    assert(math.clamp(value, min, max) == max, string.format("math.clamp(%d, %d, %d) should return %d. Range is [%d, %d]", value, min, max, max, min, max))
end