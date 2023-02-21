---@class Effect: Unit
---@operator call(): TrackerEffect
Effect = Object:extend()



---@class TrackerEffect: Effect
---@operator call(): TrackerEffect
TrackerEffect = Effect:extend()


---@param unit Unit
function TrackerEffect:new(unit)
    self.unit = unit
    self.alive = true
end

function TrackerEffect:update(dt)
    if self.unit then
        self.alive = self.unit.alive
    end
end

function TrackerEffect:render()
    if self.unit then
        love.graphics.circle("line", self.unit.pos.x, self.unit.pos.y, 8)
    end
end

function TrackerEffect:destroy()
    self.unit = nil
    self.alive = false
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