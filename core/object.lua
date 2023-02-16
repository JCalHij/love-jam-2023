--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--

--[[
  
]]
---@class Object
---@operator call(): Object
Object = {
  super = nil
}
Object.__index = Object


--[[

]]
---@param ... unknown
function Object:new(...)
end


--[[
  
]]
---@return Object
function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


--[[
  
]]
---@param ... unknown
function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


--[[
  
]]
---@param T Object
---@return boolean
function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


--[[
  
]]
---@return Object
function Object:class()
  return self.__index
end


--[[
  
]]
---@return string
function Object:class_name()
  return "Object"
end


--[[
  
]]
function Object:destroy()
end


--[[
  
]]
---@return string
function Object:__tostring()
  return "Object"
end


--[[
  
]]
---@param ... unknown
---@return Object
function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end
