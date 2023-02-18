---@class GameplayRoom: Object
---@operator call(): GameplayRoom
GameplayRoom = Object:extend()


---@param app GameApp
function GameplayRoom:new(app)
    self.app = app
    self.objects = {}  ---@type table
end


function GameplayRoom:init()
    -- Clear objects and add player
    for _, object in ipairs(self.objects) do
        object:destroy()
    end

    self.objects = {
        Player({ pos = Vector2(50, 50) }),
    }
end


function GameplayRoom:update(dt)
    for _, object in ipairs(self.objects) do
        object:update(dt)
    end
end


function GameplayRoom:render()
    for _, object in ipairs(self.objects) do
        object:render()
    end
end


function GameplayRoom:add_object(class, params)
    local object = class(params)
    table.insert(self.objects, object)
    return object
end