---@class GameApp: Object
---@operator call(): GameApp
GameApp = Object:extend()


function GameApp:new()
    ---@type {[string]: GameplayRoom}
    self.rooms= {
        ["gameplay"] = GameplayRoom(self)
    }
    self.current_room = "gameplay"
end


function GameApp:update(dt)
    self.rooms[self.current_room]:update(dt)
end


function GameApp:render()
    self.rooms[self.current_room]:render()
end