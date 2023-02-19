---@class UnitDef
---@field position Vec2
---@field hit_points integer
---@field attack_damage integer
---@field attack_speed number
---@field move_speed number
---@field collider_radius integer


---@class Unit: Object
Unit = Object:extend()


---@param room GameplayRoom
---@param unitDef UnitDef
function Unit:new(room, unitDef)
    self.room = room
    self.pos = unitDef.position
    self.hp = unitDef.hit_points
    self.max_hp = unitDef.hit_points
    self.attack_damage = unitDef.attack_damage
    self.attack_speed = unitDef.attack_speed
    self.move_speed = unitDef.move_speed
    self.alive = true
    self.collider_radius = unitDef.collider_radius
end
function Unit:update(dt) end
function Unit:render() end
---@param damage integer
---@param attacker Unit
function Unit:take_damage(damage, attacker)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self.alive = false
    end
end
---@param other Unit
function Unit:distance_to(other)
    return (other.pos - self.pos):len()
end



---------------------------------------------------------------------------------



---@class KnightState: Object
local KnightState = Object:extend()
function KnightState:update(dt) end



---@class KnightIdleState: KnightState
local KnightIdleState = KnightState:extend()

---@class KnightMovingState: KnightState
local KnightMovingState = KnightState:extend()

---@class KnightAttackingState: KnightState
local KnightAttackingState = KnightState:extend()



---@param knight Knight
function KnightIdleState:new(knight)
    self.knight = knight
end

function KnightIdleState:update(dt)
    -- If collision with an enemy, select it as next target
    ---@param unit Unit
    local filter = function(unit)
        -- The target unit class needs to be one of the following
        local valid_unit_classes = { NormalZombie }
        if table.ifind(valid_unit_classes, unit:class()) == nil then
            return false
        end
        -- Collision between target unit and self is required
        local sum_radius = self.knight.collider_radius + unit.collider_radius
        if self.knight:distance_to(unit) > sum_radius then
            return false
        end
        -- All checks OK
        return true
    end
    local new_targets = self.knight.room:filter_units(filter)
    if #new_targets > 0 then
        self.knight.targets = new_targets
        self.knight.state = KnightAttackingState(self.knight)
        self:destroy()
    end
end

function KnightIdleState:destroy()
    self.knight = nil
end



---@param knight Knight
function KnightMovingState:new(knight)
    self.knight = knight
end

function KnightMovingState:update(dt)
    local target = self.knight.targets[1]
    if not target then
        self.knight.state = KnightIdleState(self.knight)
        self:destroy()
    end

    -- Check for collision with target
    local sum_colliders = target.collider_radius + self.knight.collider_radius
    local move_direction = target.pos - self.knight.pos
    if move_direction:len() <= sum_colliders then
        printf("Knight collided with target. Switching to KnightAttackingState")
        self.knight.state = KnightAttackingState(self.knight)
        self:destroy()
        return
    end

    -- Move towards the target
    local delta_pos = move_direction:normalizeInplace() * self.knight.move_speed * dt
    self.knight.pos = self.knight.pos + delta_pos
end

function KnightMovingState:destroy()
    self.knight = nil
end



---@param knight Knight
function KnightAttackingState:new(knight)
    self.knight = knight
    self.attack_timer = knight.attack_speed/2
end

function KnightAttackingState:update(dt)
    -- Before attacking, a minimum is distance to the target is required,
    -- otherwise we switch to moving
    local target = self.knight.targets[1]
    if not target or self.knight:distance_to(target) > 1.5*(self.knight.collider_radius+target.collider_radius) then
        self.knight.state = KnightMovingState(self.knight)
        self:destroy()
        return
    end

    self.attack_timer = self.attack_timer - dt
    if self.attack_timer <= 0 then
        printf("Knight attacking!")
        -- Reset timer
        self.attack_timer = self.attack_timer + self.knight.attack_speed
        -- Attack
        target:take_damage(self.knight.attack_damage, self.knight)
        if not target.alive then
            printf("Target is dead!")
            -- Remove target from list and go to the next one
            table.remove(self.knight.targets, 1)
            if #self.knight.targets > 0 then
                self.knight.state = KnightMovingState(self.knight)
            else
                self.knight.state = KnightIdleState(self.knight)
            end
            self:destroy()
        end
    end
end

function KnightAttackingState:destroy()
    self.knight = nil
end



---@class Knight: Unit
---@operator call(): Knight
Knight = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function Knight:new(room, position)
    ---@type UnitDef
    local BaseKnightDef = {
        position = position,
        hit_points = 1,
        move_speed = 60,
        attack_damage = 1,
        attack_speed = 1.0,
        collider_radius = 5,
    }
    Knight.super.new(self, room, BaseKnightDef)

    self.targets = {}  ---@type Unit[]
    self.state = KnightIdleState(self)  ---@type KnightState
end

function Knight:update(dt)
    self.state:update(dt)
end

function Knight:render()
    SetDrawColor({0, 1, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end

---@param targets Unit[]
function Knight:set_targets(targets)
    if self.state:class() == KnightIdleState then
        printf("Knight has now been assigned %d targets", #targets)
        self.targets = targets
        self.state = KnightMovingState(self)
        return true
    end
    return false
end

---@param damage integer
---@param attacker Unit
function Knight:take_damage(damage, attacker)
    -- Knight does not take damage
end




---------------------------------------------------------------------------------



---@class Princess: Unit
---@operator call(): Princess
Princess = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function Princess:new(room, position)
    ---@type UnitDef
    local BasePrincessDef = {
        position = position,
        hit_points = 1,
        move_speed = 0,
        attack_damage = 0,
        attack_speed = 0.0,
        collider_radius = 5,
    }
    Princess.super.new(self, room, BasePrincessDef)
end

function Princess:render()
    SetDrawColor({1, 0, 1, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end

---@param damage integer
---@param attacker Unit
function Princess:take_damage(damage, attacker)
    -- The Princess unit does not take damage, but it signals the end of the game (lost condition)
end



---------------------------------------------------------------------------------



---@class MagicShield: Unit
---@operator call(): MagicShield
MagicShield = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function MagicShield:new(room, position)
    ---@type UnitDef
    local BaseMagicShieldDef = {
        position = position,
        hit_points = 10,
        move_speed = 0,
        attack_damage = 0,
        attack_speed = 0.0,
        collider_radius = 50,
    }
    MagicShield.super.new(self, room, BaseMagicShieldDef)
end

function MagicShield:render()
    SetDrawColor({1, 1, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end



---------------------------------------------------------------------------------


---@class ZombieState: Object
local ZombieState = Object:extend()
function ZombieState:update(dt) end



---@class ZombieMovingState: ZombieState
local ZombieMovingState = ZombieState:extend()

---@class ZombieAttackingState: ZombieState
local ZombieAttackingState = ZombieState:extend()



---@param zombie NormalZombie
function ZombieMovingState:new(zombie)
    self.zombie = zombie
end

function ZombieMovingState:update(dt)
    -- If collision with allied unit, switch to attack.
    ---@param unit Unit
    local filter = function(unit)
        -- The target unit class needs to be one of the following
        local valid_unit_classes = { Knight, MagicShield, Princess }
        if table.ifind(valid_unit_classes, unit:class()) == nil then
            return false
        end
        -- Collision between target unit and self is required
        local sum_radius = self.zombie.collider_radius + unit.collider_radius
        local delta_pos = unit.pos - self.zombie.pos
        if delta_pos:len() > sum_radius then
            return false
        end
        -- All checks OK
        return true
    end
    local collided_wit_allied_units = self.zombie.room:filter_units(filter)
    if #collided_wit_allied_units > 0  then
        -- We are colliding with a unit we can attack, so the zombie switches to attack mode
        self.zombie.target = collided_wit_allied_units[1]
        self.zombie.state = ZombieAttackingState(self.zombie)
        self:destroy()
    else
        -- Nothing can stop the zombie, so move towards the princess.
        local move_vector = (self.zombie.room.princess.pos - self.zombie.pos):normalizeInplace()
        self.zombie.pos = self.zombie.pos + move_vector*self.zombie.move_speed*dt
    end
end

function ZombieMovingState:destroy()
    self.zombie = nil
end



---@param zombie NormalZombie
function ZombieAttackingState:new(zombie)
    self.zombie = zombie
    self.attack_timer = zombie.attack_speed  -- Zombies start with full cooldown of attack
end

function ZombieAttackingState:update(dt)
    -- Before attacking, a minimum is distance to the target is required,
    -- otherwise we switch to moving
    local target = self.zombie.target
    if not target or self.zombie:distance_to(target) > 1.5*(self.zombie.collider_radius+target.collider_radius) then
        self.zombie.state = ZombieMovingState(self.zombie)
        self:destroy()
        return
    end

    self.attack_timer = self.attack_timer - dt
    if self.attack_timer <= 0 then
        printf("Zombie attacking!")
        -- Reset timer
        self.attack_timer = self.attack_timer + self.zombie.attack_speed
        -- Attack
        target:take_damage(self.zombie.attack_damage, self.zombie)
        if not target.alive then
            printf("Target is dead!")
            -- Move towards the target
            self.zombie.target = nil
            self.zombie.state = ZombieMovingState(self.zombie)
            self:destroy()
        end
    end
end

function ZombieAttackingState:destroy()
    self.zombie = nil
end




---@class NormalZombie: Unit
---@operator call(): NormalZombie
NormalZombie = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function NormalZombie:new(room, position)
    ---@type UnitDef
    local BaseNormalZombieDef = {
        position = position,
        hit_points = 3,
        move_speed = 20,
        attack_damage = 1,
        attack_speed = 2.0,
        collider_radius = 15,
    }
    NormalZombie.super.new(self, room, BaseNormalZombieDef)

    self.state = ZombieMovingState(self)
    self.target = nil  ---@type Unit
end

function NormalZombie:update(dt)
    self.state:update(dt)
end

function NormalZombie:render()
    SetDrawColor({1, 0, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end

function NormalZombie:destroy()
    self.room.enemies_left = self.room.enemies_left - 1
    self.state:destroy()
    self.state = nil
    self.room = nil
end