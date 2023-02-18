---@class GameplayRoom: Object
---@operator call(): GameplayRoom
GameplayRoom = Object:extend()


---@param app GameApp
function GameplayRoom:new(app)
    self.app = app
    self.objects = {}  ---@type table
    self.units = {}  ---@type Unit[]
    self.effects = {}  ---@type Effect[]

    self.player = PlayerController(self)

    self.knight = nil  ---@type Knight
end


function GameplayRoom:init()
    -- Clear units
    for _, unit in ipairs(self.units) do
        unit:destroy()
    end
    self.units = {}

    self.knight = self:spawn_unit(Knight, Vector2(100, 100))
    self.princess = self:spawn_unit(Princess, Vector2(VirtualWidth/2, VirtualHeight/2))

    for i=1,5 do
        self:spawn_unit(NormalZombie)
    end
end


function GameplayRoom:update(dt)
    self.player:update(dt)

    for _, unit in ipairs(self.units) do
        unit:update(dt)
    end

    for _, effect in ipairs(self.effects) do
        effect:update(dt)
    end

    for i=#self.units, 1, -1 do
        local unit = self.units[i]
        if not unit.alive then
            unit:destroy()
            table.remove(self.units, i)            
        end
    end

    for i=#self.effects, 1, -1 do
        local effect = self.effects[i]
        if not effect.alive then
            effect:destroy()
            table.remove(self.effects, i)            
        end
    end
end


function GameplayRoom:render()
    for _, unit in ipairs(self.units) do
        unit:render()
    end
    for _, effect in ipairs(self.effects) do
        effect:render()
    end
end


---@param unit_class Unit
---@param position? Vec2
function GameplayRoom:spawn_unit(unit_class, position)
    local random_position = position or Vector2(math.random(0, 300), math.random(0, 300))
    local unit = unit_class(random_position)
    table.insert(self.units, unit)
    return unit
end


---@param effect Effect
function GameplayRoom:add_effect(effect)
    table.insert(self.effects, effect)
end


---@param fn fun(unit: Unit): boolean
---@return Unit[]
function GameplayRoom:filter_units(fn)
    local units = {}
    for _, unit in ipairs(self.units) do
        if fn(unit) then
            table.insert(units, unit)
        end
    end
    return units
end