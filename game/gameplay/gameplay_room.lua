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
    self.spawner = nil  ---@type EnemySpawner

    self.enemies_left = 0
    self.player_points = 0
    self.max_attack_chain_count = 0

    self.show_game_ui = false
    self.show_end_screen_ui = false
    self.show_upgrade_ui = false

    self.upgrade_panel = nil  ---@type UpgradePanel

    ---@type WaveData[]
    self.waves = {
        -- Level 1
        {
            { class =  NormalZombie, amount = 2 },
            { class =  FastZombie, amount = 0 },
            { class =  FatZombie, amount = 0 },
        },
        -- Level 2
        {
            { class =  NormalZombie, amount = 3 },
            { class =  FastZombie, amount = 1 },
            { class =  FatZombie, amount = 0 },
        },
        -- Level 3
        {
            { class =  NormalZombie, amount = 3 },
            { class =  FastZombie, amount = 0 },
            { class =  FatZombie, amount = 1 },
        },
        -- Level 4
        {
            { class =  NormalZombie, amount = 2 },
            { class =  FastZombie, amount = 2 },
            { class =  FatZombie, amount = 2 },
        },
        -- Level 5
        {
            { class =  NormalZombie, amount = 3 },
            { class =  FastZombie, amount = 2 },
            { class =  FatZombie, amount = 3 },
        },
        -- Level 6
        {
            { class =  NormalZombie, amount = 2 },
            { class =  FastZombie, amount = 4 },
            { class =  FatZombie, amount = 4 },
        },
        -- Level 7
        {
            { class =  NormalZombie, amount = 0 },
            { class =  FastZombie, amount = 5 },
            { class =  FatZombie, amount = 5 },
        },
        -- Level 8
        {
            { class =  NormalZombie, amount = 0 },
            { class =  FastZombie, amount = 10 },
            { class =  FatZombie, amount = 0 },
        },
        -- Level 9
        {
            { class =  NormalZombie, amount = 0 },
            { class =  FastZombie, amount = 7 },
            { class =  FatZombie, amount = 7 },
        },
        -- Level 10
        {
            { class =  NormalZombie, amount = 8 },
            { class =  FastZombie, amount = 8 },
            { class =  FatZombie, amount = 8 },
        },
    }
    self.current_wave = 1

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
        -- Points received depend on current attack chain
        self.player_points = self.player_points + 8*self.knight.attack_chain_count
        self.max_attack_chain_count = math.max(self.max_attack_chain_count, self.knight.attack_chain_count)
        -- Update number of enemies left, and finish wave when done
        self.enemies_left = self.enemies_left - 1
        if not self.spawner and self.enemies_left <= 0 then
            -- Wave completed, go to the next one
            self.current_wave = self.current_wave + 1
            self.show_game_ui = false
            if self.current_wave > #self.waves then
                -- Player won
                local duration = 2.0
                self:add_effect(WonScreenEffect(duration))
                self.app.timer:after(duration, function()
                    -- Remove all units when duration has elapsed
                    self:clear_units()
                    self.enemies_left = 0
                    self.player_points = 0
                    -- Create buttons to replay or exit when duration has elapsed
                    self.show_end_screen_ui = true
                end)
            else
                self.show_upgrade_ui = true
                self.upgrade_panel = UpgradePanel(self)
            end
        end
    end)

    self.event_layer:register(self, EnemySpawnedEvent, function (event)
        ---@cast event EnemySpawnedEvent
        self.enemies_left = self.enemies_left + 1
    end)

    self.event_layer:register(self, UpgradeRoomFinishedEvent, function (event)
        ---@cast event UpgradeRoomFinishedEvent
        self.upgrade_panel:destroy()
        self.upgrade_panel = nil
        -- Go to the next wave
        self.show_game_ui = true
        self.app.timer:after(2.0, function()
            self:new_wave()
        end)
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
    self.knight = self:spawn_unit(Knight, Vector2(VirtualWidth/2 - 30, VirtualHeight/2))
    self.princess = self:spawn_unit(Princess, Vector2(VirtualWidth/2, VirtualHeight/2))

    self.show_game_ui = true
    self.show_end_screen_ui = false
    self.show_upgrade_ui = false

    self.current_wave = 1
    self:new_wave()
end


function GameplayRoom:new_wave()
    self.show_game_ui = true
    assert(self.waves[self.current_wave], string.format("No wave data exists for wave number %d", self.current_wave))
    self.spawner = EnemySpawner(self, self.waves[self.current_wave])
    table.insert(self.units, self.spawner)
end


function GameplayRoom:update(dt)
    self.player:update(dt)

    for _, unit in ipairs(self.units) do
        unit:update(dt)
    end

    if self.spawner and not self.spawner.alive then
        self.spawner = nil
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
        self:game_ui()
    end

    if self.show_upgrade_ui then
        self:upgrade_ui()
    end

    if self.show_end_screen_ui then
        self:end_screen_ui()
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


function GameplayRoom:game_ui()
    love.graphics.print(string.format("Magic Shield %d / %d", self.magic_shield.hp, self.magic_shield:get_max_hp()), 10, 10)
    love.graphics.print(string.format("Player points %d", self.player_points), 10, 30)
    love.graphics.print(string.format("Enemies left %d", self.enemies_left), 10, 50)
    love.graphics.print(string.format("Chain %d (Max %d)", self.knight.attack_chain_count, self.max_attack_chain_count), 10, 70)
    love.graphics.print(string.format("Wave %d / %d", self.current_wave, #self.waves), 10, 90)
end


function GameplayRoom:upgrade_ui()
    if self.upgrade_panel then
        self.upgrade_panel:render()
    end
end


function GameplayRoom:end_screen_ui()
    local repeat_pressed = imgui.button({x=VirtualWidth/3, y=2*VirtualHeight/3, w=150, h=30}, "PLAY AGAIN")
    if repeat_pressed then
        self:init()
    end
    local exit_pressed = imgui.button({x=2*VirtualWidth/3, y=2*VirtualHeight/3, w=150, h=30}, "EXIT")
    if exit_pressed then
        love.event.quit()
    end
end


function GameplayRoom:destroy()
    self.event_layer:unregister(self, {PlayerLostEvent, EnemyKilledEvent, EnemySpawnedEvent, UpgradeRoomFinishedEvent})
    self.event_layer = nil
    self.app = nil
    self:clear_units()
    self.knight = nil
    self.princess = nil
    self.magic_shield = nil
    self:clear_effects()
    self.player:destroy()
    self.player = nil
end