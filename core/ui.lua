---@class UIElement: Object
---@field x number
---@field y number
---@field w number
---@field h number
---@field alive boolean
UIElement = Object:extend()

function UIElement:new(dimensions)
    self.x = dimensions.x
    self.y = dimensions.y
    self.w = dimensions.w
    self.h = dimensions.h
    self.alive = true
end

function UIElement:update()
end

function UIElement:render()
end

function UIElement:class_name()
    return "UIElement"
end

function UIElement:__tostring()
    return "UIElement"
end

function UIElement:close()
    self.alive = false
end

function UIElement:destroy()
end
