--[[
This file contains functions that act as an abstraction layer
to LÖVE. The point is to provide proper documentation that can
be used with my editor
]]

--[[
Graphics module
]]
local love_graphics_setColor = love.graphics.setColor
local love_graphics_setScissor = love.graphics.setScissor
local love_graphics_rectangle = love.graphics.rectangle


--[[

]]
---@param color Color
function SetDrawColor(color)
    love_graphics_setColor(color)
end

--[[

]]
---@param rect Rectangle
function BeginScissorMode(rect)
    love_graphics_setScissor(rect.x, rect.y, rect.w, rect.h)
end

--[[

]]
function EndScissorMode()
    love_graphics_setScissor()
end


--[[

]]
---@param rect Rectangle
function DrawRectangle(rect)
    love_graphics_rectangle("fill", rect.x, rect.y, rect.w, rect.h)
end


--[[

]]
---@param rect Rectangle
---@param r number
---@param segments integer
function DrawRectangleRounded(rect, r, segments)
    love_graphics_rectangle("fill", rect.x, rect.y, rect.w, rect.h, r, r, segments)
end


--[[

]]
---@param rect Rectangle
function DrawRectangleLines(rect)
    love_graphics_rectangle("line", rect.x, rect.y, rect.w, rect.h)
end


--[[

]]
---@param rect Rectangle
---@param r number
---@param segments integer
function DrawRectangleLinesRounded(rect, r, segments)
    love_graphics_rectangle("line", rect.x, rect.y, rect.w, rect.h, r, r, segments)
end