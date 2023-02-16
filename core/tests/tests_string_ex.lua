---@class StringExTestSuite: TestSuite
---@operator call(): StringExTestSuite
StringExTestSuite = TestSuite:extend()

function StringExTestSuite:new()
    StringExTestSuite.super.new(self, "string_ex")
end

function StringExTestSuite:test_split_separator_found()
    local s = "My tailor is rich"
    local expected_split = {"My", "tailor", "is", "rich"}

    for i, split in ipairs(string.split(s, " ")) do
        assert(split == expected_split[i], "Failed at %d -> '%s' != '%s'", i, expected_split[i], split)
    end
end

function StringExTestSuite:test_split_separator_not_found()
    local s = "My tailor is rich"
    local expected_split = {"My tailor is rich"}

    for i, split in ipairs(string.split(s, ";")) do
        assert(split == expected_split[i], "Failed at %d -> '%s' != '%s'", i, expected_split[i], split)
    end
end

function StringExTestSuite:test_builder()
    local sb = string.builder()
    local expected_string = "MyTailorIsRich"
    local s = sb:append("My"):append("Tailor"):append("Is"):append("Rich"):build()

    assert(s == expected_string, "Failed string building: Expected '%s', Got '%s'", expected_string, s)
end