---@class TitleRoom: Object
---@operator call(): TitleRoom
TitleRoom = Object:extend()


---@param app GameApp
function TitleRoom:new(app)
    self.app = app
end


function TitleRoom:init()
end


function TitleRoom:update(dt)
end


function TitleRoom:render()
end


function TitleRoom:destroy()
end