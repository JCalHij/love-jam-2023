---@class Effect: Unit
---@operator call(): Effect
Effect = Object:extend()



---@class UnitChainEffect: Effect
---@operator call(): UnitChainEffect
UnitChainEffect = Effect:extend()


function UnitChainEffect:new()
    self.units = {}  ---@type Unit[]
    self.alive = true
end

function UnitChainEffect:update(dt)
    for i=#self.units, 1, -1 do
        local unit = self.units[i]
        if not unit.alive then
            table.remove(self.units, i)
        end
    end
end

function UnitChainEffect:render()
    -- Target reticules
    for _, unit in ipairs(self.units) do
        love.graphics.circle("line", unit.pos.x, unit.pos.y, 8)
    end
    -- Chain
    if #self.units > 1 then
        for i = 1, #self.units-1 do
            local u1 = self.units[i]
            local u2 = self.units[i+1]
            love.graphics.line(u1.pos.x, u1.pos.y, u2.pos.x, u2.pos.y)
        end
    end
end

function UnitChainEffect:clear()
    self.units = {}
end

function UnitChainEffect:destroy()
    self.units = {}
    self.alive = false
end

---@param unit Unit
function UnitChainEffect:add_unit(unit)
    table.insert(self.units, unit)
end



---@class LostScreenEffect: Effect
---@operator call(): LostScreenEffect
LostScreenEffect = Effect:extend()


function LostScreenEffect:new(duration)
    self.alive = true
    self.alpha = 0.0
    self.target_alpha = 1.0
    self.fade_in_speed = self.target_alpha / duration
    self.lost_rect = {
        x = 1, y = 160,
        w = 158, h = 79
    }
    self.lost_quad = love.graphics.newQuad(self.lost_rect.x, self.lost_rect.y, self.lost_rect.w, self.lost_rect.h, g_TextureAtlas)
end

function LostScreenEffect:update(dt)
    self.alpha = math.min(self.alpha + self.fade_in_speed*dt, self.target_alpha)
end

function LostScreenEffect:render()
    SetDrawColor({0, 0, 0, self.alpha})
    DrawRectangle({x=0, y=0, w=VirtualWidth, h=VirtualHeight})
    SetDrawColor({1, 1, 1, self.alpha})
    love.graphics.draw(g_TextureAtlas, self.lost_quad, math.round((VirtualWidth-self.lost_rect.w)/2), math.round((VirtualHeight-self.lost_rect.h)/2))
    SetDrawColor({1, 1, 1, 1})
end

function LostScreenEffect:destroy()
    self.unit = nil
    self.alive = false
end



---@class WonScreenEffect: Effect
---@operator call(): WonScreenEffect
WonScreenEffect = Effect:extend()


function WonScreenEffect:new(duration)
    self.alive = true
    self.alpha = 0.0
    self.target_alpha = 1.0
    self.fade_in_speed = self.target_alpha / duration
end

function WonScreenEffect:update(dt)
    self.alpha = math.min(self.alpha + self.fade_in_speed*dt, self.target_alpha)
end

function WonScreenEffect:render()
    SetDrawColor({0, 0, 0, self.alpha})
    DrawRectangle({x=0, y=0, w=VirtualWidth, h=VirtualHeight})
    SetDrawColor({1, 1, 1, self.alpha})
    love.graphics.printf("YOU WON, CONGRATULATIONS!", 0, VirtualHeight/2, VirtualWidth, "center")
    SetDrawColor({1, 1, 1, 1})
end

function WonScreenEffect:destroy()
    self.unit = nil
    self.alive = false
end



---@class MagicShieldHitEffect: Effect
---@operator call(): MagicShieldHitEffect
MagicShieldHitEffect = Effect:extend()

---@param magic_shield MagicShield
function MagicShieldHitEffect:new(magic_shield)
    self.alive = true
    self.magic_shield = magic_shield
    local rects = {
        {x = 48*1, y = 32, w = magic_shield.w, h = magic_shield.h},
        {x = 48*2, y = 32, w = magic_shield.w, h = magic_shield.h},
        {x = 48*3, y = 32, w = magic_shield.w, h = magic_shield.h},
        {x = 48*4, y = 32, w = magic_shield.w, h = magic_shield.h},
        {x = 48*5, y = 32, w = magic_shield.w, h = magic_shield.h},
    }  ---@type Rectangle[]
    self.quads = {}
    for _, rect in ipairs(rects) do
        table.insert(self.quads, love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h, g_TextureAtlas))
    end
    self.times = { 0.075, 0.075, 0.075, 0.075, 0.075 } ---@type number[]
    self.index = 1
    self.time = 0
end

function MagicShieldHitEffect:update(dt)
    self.time = self.time + dt
    if self.time >= self.times[self.index] then
        self.time = self.time - self.times[self.index]
        self.index = self.index + 1
        if self.index > #self.quads then
            self.alive = false
        end
    end
end

function MagicShieldHitEffect:render()
    SetDrawColor(self.magic_shield.color)
    love.graphics.draw(g_TextureAtlas, self.quads[self.index], self.magic_shield.pos.x - self.magic_shield.w/2, self.magic_shield.pos.y - self.magic_shield.h/2)
    SetDrawColor({1,1,1,1})
end

function MagicShieldHitEffect:destroy()
    self.times = nil
    self.quads = nil
end



---@class KnightAttackEffect: Effect
---@operator call(): KnightAttackEffect
KnightAttackEffect = Effect:extend()

---@param target Unit
function KnightAttackEffect:new(target)
    self.alive = true
    self.target = target
    self.w, self.h = target.w, target.h
    self.pos = self.target.pos
    self.quad = love.graphics.newQuad(64, 0, 16, 16, g_TextureAtlas)
    self.time = 0.075
end

function KnightAttackEffect:update(dt)
    self.time = self.time - dt
    if self.time <= 0 then
        self.alive = false
    end
end

function KnightAttackEffect:render()
    love.graphics.draw(g_TextureAtlas, self.quad, self.pos.x - self.w/2, self.pos.y - self.h/2)
end

function KnightAttackEffect:destroy()
    self.target = nil
    self.quad = nil
end