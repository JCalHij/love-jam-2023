---@class GameplayRoom: Object
---@operator call(): GameplayRoom
GameplayRoom = Object:extend()


---@param app GameApp
function GameplayRoom:new(app)
    self.app = app
    self.objects = {}  ---@type table
    self.units = {}  ---@type Unit[]

    self.player = PlayerController(self)

    self.knight = nil
end


function GameplayRoom:init()
    -- Clear units
    for _, unit in ipairs(self.units) do
        unit:destroy()
    end
    self.units = {}

    self.knight = self:spawn_unit(Knight, Vector2(100, 100))

    for i=1,5 do
        self:spawn_unit(NormalZombie)
    end
end


function GameplayRoom:update(dt)
    self.player:update(dt)

    for _, unit in ipairs(self.units) do
        unit:update(dt)
    end
end


function GameplayRoom:render()
    for _, unit in ipairs(self.units) do
        unit:render()
    end
end


---@param unit_class Unit
---@param position? Vec2
function GameplayRoom:spawn_unit(unit_class, position)
    local random_position = position or Vector2(math.random(0, 300), math.random(0, 300))
    local unit = unit_class(random_position)
    table.insert(self.units, unit)
    return unit
end