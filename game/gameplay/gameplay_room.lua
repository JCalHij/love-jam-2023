---@class GameplayRoom: Object
---@operator call(): GameplayRoom
GameplayRoom = Object:extend()


---@param app GameApp
function GameplayRoom:new(app)
    self.app = app
    self.objects = {}  ---@type table
    self.units = {}  ---@type Unit[]
end


function GameplayRoom:init()
    -- Clear units
    for _, unit in ipairs(self.units) do
        unit:destroy()
    end

    self.units = {
        Knight(Vector2(100, 100)),
    }

    for i=1,5 do
        self:spawn_enemy()
    end
end


function GameplayRoom:update(dt)
    for _, unit in ipairs(self.units) do
        unit:update(dt)
    end
end


function GameplayRoom:render()
    for _, unit in ipairs(self.units) do
        unit:render()
    end
end


function GameplayRoom:spawn_enemy()
    local random_position = Vector2(math.random(0, 300), math.random(0, 300))
    table.insert(self.units, NormalZombie(random_position))
end