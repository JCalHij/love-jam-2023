---@class UnitDef
---@field hit_points integer
---@field attack_damage integer
---@field attack_speed number
---@field move_speed number
---@field collider_radius integer


---@class Unit: Object
Unit = Object:extend()


---@param room GameplayRoom
---@param position Vec2
---@param unitDef UnitDef
function Unit:new(room, position, unitDef)
    self.room = room
    self.pos = position
    self.hp = unitDef.hit_points
    self.max_hp = unitDef.hit_points
    self.attack_damage = unitDef.attack_damage
    self.attack_speed = unitDef.attack_speed
    self.move_speed = unitDef.move_speed
    self.alive = true
    self.collider_radius = unitDef.collider_radius
    self.ignore_collisions = false
end
function Unit:update(dt) end
function Unit:render() end
---@param damage integer
---@param attacker Unit
function Unit:take_damage(damage, attacker)
    self.hp = math.max(self.hp - damage, 0)
    if self.hp <= 0 then
        self.alive = false
    end
end
---@param other Unit
function Unit:distance_to(other)
    return (other.pos - self.pos):len()
end



---------------------------------------------------------------------------------


---@type {[string]: UnitDef}
local BaseUnitStats = {
    Knight = {
        hit_points = 1,
        move_speed = 60,
        attack_damage = 1,
        attack_speed = 1.0,
        collider_radius = 5,
    },
    Princess = {
        hit_points = 1,
        move_speed = 0,
        attack_damage = 0,
        attack_speed = 0.0,
        collider_radius = 5,
    },
    MagicShield = {
        hit_points = 6,
        move_speed = 0,
        attack_damage = 0,
        attack_speed = 0.0,
        collider_radius = 24,
    },
    NormalZombie = {
        hit_points = 2,
        move_speed = 15,
        attack_damage = 1,
        attack_speed = 1.6,
        collider_radius = 8,
    },
    FastZombie = {
        hit_points = 2,
        move_speed = 25,
        attack_damage = 1,
        attack_speed = 1.0,
        collider_radius = 5,
    },
    FatZombie = {
        hit_points = 5,
        move_speed = 10,
        attack_damage = 3,
        attack_speed = 2.0,
        collider_radius = 10,
    },
}



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

---@class KnightKnockbackState: KnightState
local KnightKnockbackState = KnightState:extend()



---@param knight Knight
function KnightIdleState:new(knight)
    self.knight = knight

    self.knight:reset_chain_count()
end

function KnightIdleState:update(dt)
    -- If collision with an enemy, select it as next target
    ---@param unit Unit
    local filter = function(unit)
        -- The target unit class needs to be one of the following
        local valid_unit_classes = { NormalZombie, FastZombie, FatZombie }
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
        return
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
    local delta_pos = move_direction:normalizeInplace() * self.knight:get_move_speed() * dt
    self.knight.pos = self.knight.pos + delta_pos
end

function KnightMovingState:destroy()
    self.knight = nil
end



---@param knight Knight
function KnightAttackingState:new(knight)
    self.knight = knight
    self.attack_timer = knight:get_attack_speed()
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
        -- Reset timer
        self.attack_timer = self.attack_timer + self.knight:get_attack_speed()
        -- Attack
        target:take_damage(self.knight:get_attack_damage(), self.knight)
        self.knight.room:add_effect(KnightAttackEffect(target))
        if not target.alive then
            self.knight:increase_chain_count()
            self.knight.room.event_layer:notify(EnemyKilledEvent(target:class()))
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



---@param knight Knight
function KnightKnockbackState:new(knight)
    self.knight = knight
    self.knockback_time = 0.2
end

function KnightKnockbackState:update(dt)
    self.knockback_time = self.knockback_time - dt
    if self.knockback_time <= 0.0 then
        self.knight.state = KnightMovingState(self.knight)
        self:destroy()
    else
        -- Actual knockback movement
        self.knight.pos = self.knight.pos + self.knight.knockback_vector * dt
    end
end

function KnightKnockbackState:destroy()
    self.knight = nil
end



---@class Knight: Unit
---@operator call(): Knight
Knight = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function Knight:new(room, position)
    Knight.super.new(self, room, position, BaseUnitStats.Knight)
    self.modifiers = {
        -- Attack damage
        attack_damage_num_upgrades = 0,
        attack_damage_delta = 1,
        -- Attack speed
        attack_speed_num_upgrades = 0,
        attack_speed_delta = -0.05,
        -- Move speed
        move_speed_num_upgrades = 0,
        move_speed_delta = 5,
    }

    self.targets = {}  ---@type Unit[]
    self.attack_chain_count = 0  -- Number of successive attacks in a chain. Reset when going to idle
    self.state = KnightIdleState(self)  ---@type KnightState
    self.knockback_vector = Vector2(0, 0)
    self.w = 16
    self.h = 16
    local QuadDef = {
        x = 48, y = 0, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)
end

function Knight:increase_chain_count()
    self.attack_chain_count = self.attack_chain_count + 1
end

function Knight:reset_chain_count()
    self.attack_chain_count = 0
end

function Knight:get_attack_damage()
    return self.attack_damage + self.modifiers.attack_damage_delta*self.modifiers.attack_damage_num_upgrades
end

function Knight:get_attack_speed()
    return self.attack_speed + self.modifiers.attack_speed_delta*self.modifiers.attack_speed_num_upgrades
end

function Knight:get_move_speed()
    return self.move_speed + self.modifiers.move_speed_delta*self.modifiers.move_speed_num_upgrades
end

function Knight:update(dt)
    self.state:update(dt)
end

function Knight:render()
    love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
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
    -- Knight does not take damage, but it gets knocked back by the enemy zombies
    local knoback_direction = (self.pos - attacker.pos):normalizeInplace()  ---@type Vec2
    --//TODO[javi]: knockback magnitude depending on enemy type?
    local magnitude = 200
    self.knockback_vector = magnitude * knoback_direction
    self.state:destroy()
    self.state = KnightKnockbackState(self)
end




---------------------------------------------------------------------------------



---@class Princess: Unit
---@operator call(): Princess
Princess = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function Princess:new(room, position)
    Princess.super.new(self, room, position, BaseUnitStats.Princess)
    self.dead = false ---@type boolean Different than "alive" property, signals that the princess has been attacked and the game is done

    self.w = 16
    self.h = 16
    local QuadDef = {
        x = 32, y = 0, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)
end

function Princess:render()
    love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
end

---@param damage integer
---@param attacker Unit
function Princess:take_damage(damage, attacker)
    -- The Princess unit does not take damage, but it signals the end of the game (lost condition)
    if not self.dead then
        self.dead = true
        self.room.event_layer:notify(PlayerLostEvent())
    end
end



---------------------------------------------------------------------------------


---@class ZombieState: Object
local ZombieState = Object:extend()
function ZombieState:update(dt) end



---@class ZombieMovingState: ZombieState
local ZombieMovingState = ZombieState:extend()

---@class ZombieAttackingState: ZombieState
local ZombieAttackingState = ZombieState:extend()

---@class ZombieKnockbackState: ZombieState
local ZombieKnockbackState = ZombieState:extend()



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
        -- Target unit can ignore collisions
        if unit.ignore_collisions then
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
    -- Before attacking, a minimum distance to the target is required,
    -- otherwise we switch to moving.
    local target = self.zombie.target
    if not target or self.zombie:distance_to(target) > 1.5*(self.zombie.collider_radius+target.collider_radius) then
        self.zombie.state = ZombieMovingState(self.zombie)
        self:destroy()
        return
    end

    self.attack_timer = self.attack_timer - dt
    if self.attack_timer <= 0 then
        printf("Zombie attacking!")
        table.random(g_SoundEffects.zombie_attack):play()
        -- Reset timer
        self.attack_timer = self.attack_timer + self.zombie.attack_speed
        -- Attack
        target:take_damage(self.zombie.attack_damage, self.zombie)
        if not target.alive and self.zombie then
            printf("Target is dead!")
            -- Move towards the target, as current is dead
            self.zombie.target = nil
            self.zombie.state = ZombieMovingState(self.zombie)
            self:destroy()
        end
    end
end

function ZombieAttackingState:destroy()
    self.zombie = nil
end



---@param zombie NormalZombie
function ZombieKnockbackState:new(zombie)
    self.zombie = zombie
    self.knockback_time = 0.4
end

function ZombieKnockbackState:update(dt)
    self.knockback_time = self.knockback_time - dt
    if self.knockback_time <= 0.0 then
        self.zombie.state = ZombieMovingState(self.zombie)
        self:destroy()
    else
        -- Actual knockback movement
        self.zombie.pos = self.zombie.pos + self.zombie.knockback_vector * dt
    end
end

function ZombieKnockbackState:destroy()
    self.zombie = nil
end




---@class EnemyZombieBase: Unit
---@operator call(): EnemyZombieBase
EnemyZombieBase = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
---@param definition UnitDef
function EnemyZombieBase:new(room, position, definition)
    EnemyZombieBase.super.new(self, room, position, definition)

    self.state = ZombieMovingState(self)
    self.target = nil  ---@type Unit
    self.knockback_vector = Vector2(0, 0)

    table.random(g_SoundEffects.zombie_spawn):play()
end

function EnemyZombieBase:update(dt)
    self.state:update(dt)
end

function EnemyZombieBase:render()
    SetDrawColor({1, 0, 0, 1})
    love.graphics.circle("line", self.pos.x, self.pos.y, self.collider_radius)
    SetDrawColor({1, 1, 1, 1})
end

function EnemyZombieBase:destroy()
    self.state:destroy()
    self.state = nil
    self.room = nil
end



---@class NormalZombie: EnemyZombieBase
---@operator call(): NormalZombie
NormalZombie = EnemyZombieBase:extend()


---@param room GameplayRoom
---@param position Vec2
function NormalZombie:new(room, position)
    NormalZombie.super.new(self, room, position, BaseUnitStats.NormalZombie)
    self.w = 16
    self.h = 16
    local QuadDef = {
        x = 0, y = 16, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)
end

function NormalZombie:render()
    love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
end



---@class FastZombie: EnemyZombieBase
---@operator call(): FastZombie
FastZombie = EnemyZombieBase:extend()


---@param room GameplayRoom
---@param position Vec2
function FastZombie:new(room, position)
    FastZombie.super.new(self, room, position, BaseUnitStats.FastZombie)
    self.w = 16
    self.h = 16
    local QuadDef = {
        x = 16, y = 16, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)
end

function FastZombie:render()
    love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
end



---@class FatZombie: EnemyZombieBase
---@operator call(): FatZombie
FatZombie = EnemyZombieBase:extend()


---@param room GameplayRoom
---@param position Vec2
function FatZombie:new(room, position)
    FatZombie.super.new(self, room, position, BaseUnitStats.FatZombie)
    self.w = 16
    self.h = 16
    local QuadDef = {
        x = 32, y = 16, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)
end

function FatZombie:render()
    love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
end



---------------------------------------------------------------------------------



---@class MagicShield: Unit
---@operator call(): MagicShield
MagicShield = Unit:extend()


---@param room GameplayRoom
---@param position Vec2
function MagicShield:new(room, position)
    MagicShield.super.new(self, room, position, BaseUnitStats.MagicShield)

    self.modifiers = {
        -- Max HP
        max_hp_num_upgrades = 0,
        max_hp_delta = 1,
    }

    self.w = 48
    self.h = 48
    local QuadDef = {
        x = 0, y = 32, w = self.w, h = self.h,
    }
    self.quad = love.graphics.newQuad(QuadDef.x, QuadDef.y, QuadDef.w, QuadDef.h, g_TextureAtlas)

    self.colors = {
        high_hp = {106/255, 190/255, 48/255, 1.0}, ---@type Color green
        medium_hp = {223/255, 113/255, 38/255, 1.0}, ---@type Color orange
        low_hp = {182/255, 50/255, 50/255, 1.0}, ---@type Color red
        -- Backups
        yellow = {251/255, 242/255, 54/255, 1.0}, ---@type Color yellow
    }
    self.color = self.colors.high_hp
end

function MagicShield:get_max_hp()
    return self.max_hp + self.modifiers.max_hp_delta*self.modifiers.max_hp_num_upgrades
end

function MagicShield:update(dt)
    self.ignore_collisions = self.hp <= 0
    -- Shield color
    do
        local hp_percentage = self.hp / self:get_max_hp()

        if hp_percentage >= 0.75 then
            self.color = self.colors.high_hp
        elseif hp_percentage >= 0.33 then
            self.color = self.colors.medium_hp
        else
            self.color = self.colors.low_hp
        end
    end
end

function MagicShield:render()
    -- Render only if magic shield is active
    if self.hp > 0 then
        SetDrawColor(self.color)
        love.graphics.draw(g_TextureAtlas, self.quad, math.round(self.pos.x - self.w/2), math.round(self.pos.y - self.h/2))
        SetDrawColor({1, 1, 1, 1})
    end
end

---@param damage integer
---@param attacker Unit
function MagicShield:take_damage(damage, attacker)
    MagicShield.super.take_damage(self, damage, attacker)

    if not self.alive then
        g_SoundEffects.shield_explosion:play()
        -- The magic shield always stays alive (in game memory), but it will ignore collisions so long as its HP <= 0
        self.alive = true
        self.ignore_collisions = true
        -- If the magic shield gets destroyed, knocks back all enemy units, no matter their distance to the shield
        local enemy_units = self.room:filter_units(function (unit)
            return table.ifind({ NormalZombie, FastZombie, FatZombie }, unit:class()) ~= nil
        end)

        for _, zombie in ipairs(enemy_units) do
            ---@cast zombie EnemyZombieBase
            -- Knockback vector and magnitude
            local knockback_vector = (zombie.pos - self.pos):normalizeInplace()
            local magnitude = 600

            zombie.state:destroy()
            zombie.knockback_vector = magnitude * knockback_vector
            zombie.state = ZombieKnockbackState(zombie)
        end
    else
        self.room:add_effect(MagicShieldHitEffect(self))
    end
end



---------------------------------------------------------------------------------
---@class WaveData
---@field class table
---@field amount integer


---@class EnemySpawner: Object
---@operator call(): EnemySpawner
EnemySpawner = Object:extend()

---@param room GameplayRoom
---@param wave_data WaveData[]
function EnemySpawner:new(room, wave_data)
    self.room = room
    self.alive = true
    self.wave_data = {}
    self.spawn_delta = 0.5
    self.elapsed_time = 0

    -- Deep-copy of depth 1 from wave data, so that we can modify the amounts for each wave without modifying the original data
    for i, wave in ipairs(wave_data) do
        if wave.amount > 0 then
            local copy_wave = {}
            for k, v in pairs(wave) do
                copy_wave[k] = v
            end
            table.insert(self.wave_data, copy_wave)
        end
    end
end

function EnemySpawner:update(dt)
    if not self.alive then return end

    self.elapsed_time = self.elapsed_time + dt
    if self.elapsed_time >= self.spawn_delta then
        self.elapsed_time = self.elapsed_time - self.spawn_delta
        -- Select enemy class to spawn and their position
        local index = math.random(1, #self.wave_data)
        local wave = self.wave_data[index]
        ---@type Vec2
        local position = Vector2(VirtualWidth/2, VirtualHeight/2) + Vector2.randomDirection(VirtualWidth/2, VirtualWidth/2)
        self.room:spawn_unit(wave.class, position)
        self.room.event_layer:notify(EnemySpawnedEvent(wave.class))
        -- Update wave data
        wave.amount = wave.amount - 1
        if wave.amount <= 0 then
            -- Completed spawn of wave.class enemies
            table.remove(self.wave_data, index)
            if #self.wave_data == 0 then
                -- Completed spawn of all enemies
                self.alive = false
            end
        end
    end
end

function EnemySpawner:render() end

function EnemySpawner:destroy()
    self.room = nil
    self.wave_data = nil
end