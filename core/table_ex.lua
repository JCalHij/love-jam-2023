--[[
Extension for Lua's table module
]]

local _to_string

---@param t table
---@param ind? integer
---@param sb StringBuilder
_to_string = function(t, ind, sb)
    local ind = ind or 1
    local indents = string.rep("\t", ind)
    sb:append("{\n")
    -- Number keys not written, all values in a single line.
    if #t > 0 then
        sb:append(indents)
    end
    for _, v in ipairs(t) do
        if type(v) == "table" then
            _to_string(v, ind+1, sb)
            sb:append(string.format(",\n%s", indents))
        elseif type(v) == "string" then
            sb:append(string.format("\"%s\", ", v))
        else
            sb:append(string.format("%s, ", tostring(v)))
        end
    end
    if #t > 0 then
        sb:append("\n")
    end
    -- String keys written
    for k, v in pairs(t) do
        -- We skip all numbers, except those not covered by ipairs (zero and negative numbers)
        if type(k) ~= "number" or k < 1 then
            local key_text = type(k) == "number" and string.format("%s[%d] = ", indents, k) or string.format("%s%s = ", indents, k)
            sb:append(key_text)
            if type(v) == "table" then
                _to_string(v, ind+1, sb)
                sb:append(",\n")
            elseif type(v) == "string" then
                sb:append(string.format("\"%s\",\n", v))
            else
                sb:append(string.format("%s,\n", tostring(v)))
            end
        end
    end
    sb:append( string.format("%s}", string.rep("\t", ind-1)) )
end

--[[
Given table `t` and an optional non-negative indentation number `ind`,
this function generates a formatted string with the contents of table
`t`.

//TODO[javi]: Deterministic string.
]]
---@param t table
---@param ind? integer
---@return string
function table.tostring(t, ind)
    local sb = string.builder()
    _to_string(t, ind, sb)
    return sb:build()
end


--[[
Applies function `f` to all elements of table `t` until
an element satisfies condition given by `f`, then it 
returns true.

If none of the elements satisfy function `f`, the function
returns false.

`f` is a function that takes a key as first parameter and 
a value as its second. It must return a boolean value,
indicating if a given condition is met by key and value
pair.
]]
---@param t table
---@param f fun(K: any, V: any): boolean
---@return boolean
function table.any(t, f)
    for k, v in pairs(t) do
        if f(k, v) then
            return true
        end
    end
    return false
end


--[[
Applies function `f` to all elements of table `t`. If all
table elements satisfy the condition given by `f`, the
function returns true. 

If any of the elements does not satisfy function `f`, 
the function returns false.

`f` is a function that takes a key as first parameter and 
a value as its second. It must return a boolean value,
indicating if a given condition is met by key and value
pair.
]]
---@param t table
---@param f fun(K: any, V: any): boolean
---@return boolean
function table.all(t, f)
    for k, v in pairs(t) do
        if not f(k, v) then
            return false
        end
    end
    return true
end


--[[
Filters elements of table `t` according to filter function
`f`. Returns a table with the elements that have passed 
the given filter.
]]
---@param t table
---@param f fun(K: any, V: any): boolean
---@return table
function table.filter(t, f)
    local r = {}
    for k, v in pairs(t) do
        if f(k, v) then
            table.insert(r, v)
        end
    end
    return r
end


--[[
Tries to find element `e` on table `t`.
Returns the key to access the given element, if found,
or `nil` otherwise.
]]
---@generic K, V
---@param t table
---@param e V
---@return K?
function table.kfind(t, e)
    for k, v in pairs(t) do
        if v == e then
            return k
        end
    end
end


--[[
Tries to find element `e` on table `t`.
Returns the key to access the given element, if found,
or `nil` otherwise.
]]
---@generic V
---@param t table
---@param e V
---@return integer?
function table.ifind(t, e)
    for i, v in ipairs(t) do
        if v == e then
            return i
        end
    end
end


--[[
Chooses a random element from the ones the table `t` contains.

Works only with index-based tables.
]]
---@generic V
---@param t table
---@return V
function table.random(t)
    return t[math.random(1, #t)]
end


--[[
Creates a shallow copy of table `t`.
]]
---@param t table
---@return table
function table.copy(t)
    local c = {}
    for k, v in pairs(t) do
        c[k] = v
    end
    return c
end


--[[
Creates a deep copy of table `t`.

NOTE: Metatables do not get copied.
]]
---@param t table
---@return table
function table.deepcopy(t)
    local c = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            c[k] = table.deepcopy(v)
        else
            c[k] = v
        end
    end
    return c
end


--[[
Returns a copy of the table that can only be read.
]]
---@param t table
---@return table
function table.read_only(t)
    -- From https://www.lua.org/pil/13.4.5.html
    local proxy = {}
    local mt = {       -- create metatable
        __index = t,
        __newindex = function (t,k,v)
            error("attempt to update a read-only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end


--[[
Applies function `f` to all elements of table `t`.
]]
---@generic V
---@param t any
---@param f fun(k, v: V): V
function table.map(t, f)
    local new = {}
    for k, v in pairs(t) do
        new[k] = f(k, v)
    end
    return new
end