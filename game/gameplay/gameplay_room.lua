---@class GameplayRoom: Object
---@operator call(): GameplayRoom
GameplayRoom = Object:extend()


---@param app GameApp
function GameplayRoom:new(app)
    self.app = app
    self.event_layer = app.event_layer

    self.units = {}  ---@type Unit[]
    self.effects = {}  ---@type Effect[]

    self.player = PlayerController(self)

    self.knight = nil  ---@type Knight
    self.princess = nil  ---@type Princess
    self.magic_shield = nil  ---@type MagicShield

    self.enemies_left = 0
    self.player_points = 0

    self.show_game_ui = false
    self.show_end_screen_ui = false

    self.event_layer:register(self, PlayerLostEvent, function(event)
        ---@cast event PlayerLostEvent
        local duration = 2.0
        self:add_effect(LostScreenEffect(duration))
        self.show_game_ui = false
        self.app.timer:after(duration, function()
            -- Remove all units when duration has elapsed
            self:clear_units()
            self.enemies_left = 0
            self.player_points = 0
            -- Create buttons to replay or exit when duration has elapsed
            self.show_end_screen_ui = true
        end)
    end)

    self.event_layer:register(self, EnemyKilledEvent, function (event)
        ---@cast event EnemyKilledEvent
        --//TODO[javi]: Points received depend on enemy type and current wave
        self.player_points = self.player_points + 1
    end)
end


function GameplayRoom:clear_units()
    for _, unit in ipairs(self.units) do
        unit:destroy()
    end
    self.units = {}
end


function GameplayRoom:clear_effects()
    for _, effect in ipairs(self.effects) do
        effect:destroy()
    end
    self.effects = {}
end


function GameplayRoom:init()
    -- Clear units
    self:clear_units()
    self:clear_effects()

    -- Spawn first the magic shield, so that it gets rendered first and appears below all other units
    self.magic_shield = self:spawn_unit(MagicShield, Vector2(VirtualWidth/2, VirtualHeight/2))
    self.knight = self:spawn_unit(Knight, Vector2(100, 100))
    self.princess = self:spawn_unit(Princess, Vector2(VirtualWidth/2, VirtualHeight/2))

    for i=1,5 do
        self:spawn_unit(NormalZombie)
        self.enemies_left = self.enemies_left + 1
    end

    self.show_game_ui = true
    self.show_end_screen_ui = false
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

    -- User interface
    if self.show_game_ui then
        love.graphics.print(string.format("Magic Shield %d / %d", self.magic_shield.hp, self.magic_shield.max_hp), 10, 10)
        love.graphics.print(string.format("Player points %d", self.player_points), 10, 30)
        love.graphics.print(string.format("Enemies left %d", self.enemies_left), 10, 50)
    end

    if self.show_end_screen_ui then
        local repeat_pressed = imgui.button({x=VirtualWidth/3, y=2*VirtualHeight/3, w=150, h=30}, "PLAY AGAIN")
        if repeat_pressed then
            self:init()
        end
        local exit_pressed = imgui.button({x=2*VirtualWidth/3, y=2*VirtualHeight/3, w=150, h=30}, "EXIT")
        if exit_pressed then
            love.event.quit()
        end
    end
end


---@generic T
---@param unit_class T
---@param position? Vec2
---@return T
function GameplayRoom:spawn_unit(unit_class, position)
    local random_position = position or Vector2(math.random(0, 300), math.random(0, 300))
    local unit = unit_class(self, random_position)
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