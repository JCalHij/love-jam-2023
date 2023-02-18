---@class PlayerDef
---@field pos? Vec2
---@field room GameplayRoom


---@class Player: Object
Player = Object:extend()


---@param playerDef PlayerDef
function Player:new(playerDef)
    self.room = playerDef.room
    self.pos = playerDef.pos or Vector2(0, 0)
    self.alive = true
end


function Player:update(dt)
end


function Player:render()
    love.graphics.circle("line", self.pos.x, self.pos.y, 5)
end


function Player:destroy()
    self.pos = nil
    self.room = nil
end