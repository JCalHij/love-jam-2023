---@alias RoomName
---| "gameplay"


---@class GameApp: Object
---@operator call(): GameApp
GameApp = Object:extend()


function GameApp:new()
    self.event_layer = EventLayer("AppEventLayer", AllEventClasses)
    self.timer = Timer()  ---@type Timer
    imgui.init()

    ---@type {[RoomName]: GameplayRoom}
    self.rooms= {
        ["gameplay"] = GameplayRoom(self)
    }
    self.current_room = nil  ---@type RoomName
    self:enter("gameplay")
end


function GameApp:update(dt)
    local delta_t = input_is_key_held("space") and 5*dt or dt
    self.timer:update(delta_t)
    self.rooms[self.current_room]:update(delta_t)
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
