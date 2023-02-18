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