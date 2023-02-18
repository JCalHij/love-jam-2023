---@class UnitDef
---@field position Vec2
---@field hit_points integer
---@field attack_damage integer
---@field attack_speed number
---@field move_speed number
---@field collider_radius integer


---@class Unit: Object
Unit = Object:extend()


---@param unitDef UnitDef
function Unit:new(unitDef)
    self.pos = unitDef.position
    self.hp = unitDef.hit_points
    self.attack_damage = unitDef.attack_damage
    self.attack_speed = unitDef.attack_speed
    self.move_speed = unitDef.move_speed
    self.alive = true
    self.collider_radius = unitDef.collider_radius
end
function Unit:update(dt) end
function Unit:render() end
function Unit:take_damage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self.alive = false
    end
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
    self.attack_timer = 0
end

function KnightAttackingState:update(dt)
    self.attack_timer = self.attack_timer - dt
    if self.attack_timer <= 0 then
        printf("Knight attacking!")
        -- Reset timer
        self.attack_timer = self.attack_timer + self.knight.attack_speed
        -- Attack
        local target = self.knight.targets[1]
        target:take_damage(self.knight.attack_damage)
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


---@param position Vec2
function Knight:new(position)
    ---@type UnitDef
    local BaseKnightDef = {
        position = position,
        hit_points = 1,
        move_speed = 20,
        attack_damage = 1,
        attack_speed = 1.0,
        collider_radius = 5,
    }
    Knight.super.new(self, BaseKnightDef)

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



---------------------------------------------------------------------------------



---@class Princess: Unit
---@operator call(): Princess
Princess = Unit:extend()


---@param position Vec2
function Princess:new(position)
    ---@type UnitDef
    local BasePrincessDef = {
        position = position,
        hit_points = 1,
        move_speed = 0,
        attack_damage = 0,
        attack_speed = 0.0,
        collider_radius = 5,
    }
    Princess.super.new(self, BasePrincessDef)
end

function Princess:render()
    SetDrawColor({1, 0, 1, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end



---------------------------------------------------------------------------------



---@class NormalZombie: Unit
---@operator call(): NormalZombie
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
        collider_radius = 15,
    }
    NormalZombie.super.new(self, BaseNormalZombieDef)
end

function NormalZombie:render()
    SetDrawColor({1, 0, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 01, 1})
end