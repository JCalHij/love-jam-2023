---@type UnitDef
local KnightDef = {
    position = Vector2(50, 50),
    hit_points = 1,
    attack_damage = 1,
    move_speed = 20,
}



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
        Knight(KnightDef),
    }
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