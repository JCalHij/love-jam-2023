---@class UnitDef
---@field position Vec2
---@field hit_points integer
---@field attack_damage integer
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


---@param unitDef UnitDef
function Knight:new(unitDef)
    Knight.super.new(self, unitDef)
end

function Knight:render()
    love.graphics.circle("line", self.pos.x, self.pos.y, 5)
end
