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
end

function LostScreenEffect:update(dt)
    self.alpha = math.min(self.alpha + self.fade_in_speed*dt, self.target_alpha)
end

function LostScreenEffect:render()
    SetDrawColor({0, 0, 0, self.alpha})
    DrawRectangle({x=0, y=0, w=VirtualWidth, h=VirtualHeight})
    SetDrawColor({1, 1, 1, self.alpha})
    love.graphics.printf("YOU LOST", 0, VirtualHeight/2, VirtualWidth, "center")
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