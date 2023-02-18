---@class PlayerController: Object
---@operator call(): PlayerController
PlayerController = Object:extend()


---@param room GameplayRoom
function PlayerController:new(room)
    self.room = room
end


function PlayerController:update(dt)
end


function PlayerController:destroy()
    self.room = nil
end