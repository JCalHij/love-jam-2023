--[[
List of `TestSuite` object classes that get registered when 
extending from `TestSuite` class.

The testing framework will iterate over all elements of the
testing registry, expect them to be inheriting from
`TestSuite`, and call all methods that begin with "test".
]]
---@type TestSuite[]
local TestingRegistry = {}


--[[
The `TestSuite` class allows multiple tests to be created for a 
single group of tests, which we will call a suite.
]]
---@class TestSuite: Object
---@field name string
---@operator call(): TestSuite
TestSuite = Object:extend()

local TestSuiteExtend = TestSuite.extend

function TestSuite:extend()
    -- TestingRegistry auto-registering mechanism
    local suite_class = TestSuiteExtend(TestSuite)
    table.insert(TestingRegistry, suite_class)
    return suite_class
end

---@param suite_name string
function TestSuite:new(suite_name)
    self.name = suite_name
end


--[[
Exported function which will run all exiting tests.
]]
function run_tests()
    print("\n\nRunning tests...")

    local stats = {
        start_time = love.timer.getTime(),
        suites = 0,
        found = 0,
        failed = 0,
        passed = 0,
        failed_registry = {},
    }

    for i, suite_class in ipairs(TestingRegistry) do
        local suite = suite_class()
        stats.suites = stats.suites + 1
        printf("#-----------------------------\n> Test Suite '%s'", suite.name)
        for suite_key, suite_member in pairs(suite_class) do
            if type(suite_member) == "function" and string.find(suite_key, "test") ~= nil then
                local ok, err, result = pcall(suite_member, suite)
                local result = ok and "passed" or "failed"
                local namespace = string.format("%s::%s", suite.name, suite_key)
                printf(">> %s - %s", namespace, result)

                -- Stats update
                stats.found = stats.found + 1
                if ok then
                    stats.passed = stats.passed + 1
                else
                    stats.failed = stats.failed + 1
                    local new_failed_registry = {
                        test_namespace = namespace,
                        error_msg = err or "..."
                    }
                    table.insert(stats.failed_registry, new_failed_registry)
                end
            end
        end
    end

    local delta_time = love.timer.getTime() - stats.start_time

    printf([[#-----------------------------
Tests finished in %f milliseconds
- %d tests found in %d suites
- %d / %d passed
- %d failed]], 1000*delta_time, stats.found, stats.suites, stats.passed, stats.found, stats.failed)

    for _, failed_test_md in ipairs(stats.failed_registry) do
        printf("%s -> %s", failed_test_md.test_namespace, failed_test_md.error_msg)
    end
    print("\n")
end