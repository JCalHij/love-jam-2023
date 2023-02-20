---@alias RoomName
---| "gameplay"


---@class GameApp: Object
---@operator call(): GameApp
GameApp = Object:extend()


function GameApp:new()
    self.event_layer = EventLayer("AppEventLayer", AllEventClasses)

    ---@type {[RoomName]: GameplayRoom}
    self.rooms= {
        ["gameplay"] = GameplayRoom(self)
    }
    self.current_room = nil  ---@type RoomName
    self:enter("gameplay")
end


function GameApp:update(dt)
    self.rooms[self.current_room]:update(dt)
end


function GameApp:render()
    self.rooms[self.current_room]:render()
end


---@param room RoomName
function GameApp:enter(room)
    if self.current_room ~= nil then
        -- Exit old room?
    end
    self.current_room = room
    self.rooms[room]:init()
end
