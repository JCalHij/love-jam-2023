--[[
Extension for Lua's string module
]]

--[[
Given string `s` and separator `sep`, this functions returns a 
list of splitted strings from the original one. If no separator
is found, it returns a list of one item, the original string.
]]
---@param s string
---@param sep string
---@return string[]
function string.split(s, sep)
    if not string.find(s, sep) then return {s} end

    local splits = {}
    local start_check = 1

    while true do
        local next_id = string.find(s, sep, start_check)
        if not next_id then
            local next_str = string.sub(s, start_check, -1)
            table.insert(splits, next_str)
            break
        end
        local next_str = string.sub(s, start_check, next_id-1)
        table.insert(splits, next_str)
        start_check = next_id + 1
    end

    return splits
end


---@class StringBuilder
local StringBuilder = {}
function StringBuilder.new()
    return setmetatable({""}, StringBuilder)
end

--[[
Receives the string to append to the builder. Calls to `append` can be chained
together, as it returns the string builder object.
]]
---@param str string
---@return StringBuilder
function StringBuilder:append(str)
    -- From here https://www.lua.org/pil/11.6.html
    table.insert(self, str)
    for i= #self-1, 1, -1 do
        if string.len(self[i]) > string.len(self[i+1]) then
        break
        end
        self[i] = self[i] .. table.remove(self)
    end
    return self
end


--[[
Creates the final string, a concatenation of all appended strings
]]
---@return string
function StringBuilder:build()
    return table.concat(self)
end


--[[
Creates a string builder object, with functions `append` and `build`.

- `append` receives the string builder as its first parameter, and
the string to append as the second one. Calls to `append` can be chained
together, as it returns the string builder object.
- `build` creates the final string, a concatenation of all appended
strings.
]]
---@return StringBuilder
function string.builder()
    return StringBuilder.new()
end
