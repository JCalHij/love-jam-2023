---@class UnitDef
---@field position Vec2
---@field hit_points integer
---@field attack_damage integer
---@field attack_speed number
---@field move_speed number


---@class Unit: Object
Unit = Object:extend()


---@param unitDef UnitDef
function Unit:new(unitDef)
    self.pos = unitDef.position:clone()
    self.hp = unitDef.hit_points
    self.attack_damage = unitDef.attack_damage
    self.move_speed = unitDef.move_speed
end
function Unit:update(dt) end
function Unit:render() end



---------------------------------------------------------------------------------



---@class Knight: Unit
Knight = Unit:extend()


---@param position Vec2
function Knight:new(position)
    ---@type UnitDef
    local BaseKnightDef = {
        position = position,
        hit_points = 1,
        move_speed = 20,
        attack_damage = 1,
        attack_speed = 1.0,
    }
    Knight.super.new(self, BaseKnightDef)
end

function Knight:render()
    SetDrawColor({0, 1, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, 5)
    SetDrawColor({1, 1, 01, 1})
end



---------------------------------------------------------------------------------



---@class NormalZombie: Unit
NormalZombie = Unit:extend()


---@param position Vec2
function NormalZombie:new(position)
    ---@type UnitDef
    local BaseNormalZombieDef = {
        position = position,
        hit_points = 1,
        move_speed = 10,
        attack_damage = 1,
        attack_speed = 2.0,
    }
    NormalZombie.super.new(self, BaseNormalZombieDef)
end

function NormalZombie:render()
    SetDrawColor({1, 0, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, 5)
    SetDrawColor({1, 1, 01, 1})
end