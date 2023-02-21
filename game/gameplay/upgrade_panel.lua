---@class UpgradePanel: Object
UpgradePanel = Object:extend()


---@param room GameplayRoom
function UpgradePanel:new(room)
    self.room = room
    self.knight = room.knight
    self.magic_shield = room.magic_shield

    -- How many does the player currently have
    self.current_num_upgrades = {
        knight_attack_damage = self.knight.modifiers.attack_damage_num_upgrades,
        knight_attack_speed = self.knight.modifiers.attack_speed_num_upgrades,
        knight_move_speed = self.knight.modifiers.move_speed_num_upgrades,
    }

    -- How many have we bought in the current upgrade session
    self.delta_num_upgrades = {
        knight_attack_damage = 0,
        knight_attack_speed = 0,
        knight_move_speed = 0,
    }

    -- Maximum amount of upgrades for each parameter
    self.max_num_upgrades = {
        knight_attack_damage = 3,
        knight_attack_speed = 10,
        knight_move_speed = 10,
    }

    self.buy_text = "BUY"
    self.buy_text_width = love.graphics.getFont():getWidth(self.buy_text)*ScaleX
end


function UpgradePanel:render()
    imgui.panel({x = 30, y = 30, w = VirtualWidth-60, h = VirtualHeight-60}, "")

    self:_render_attack_damage()
    self:_render_attack_speed()
    self:_render_move_speed()

    self:_buy_button()
end


function UpgradePanel:_render_attack_damage()
    local x, y = 50, 50
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Attack Damage: %d", self.knight:get_attack_damage()))

    local can_sell = self.delta_num_upgrades.knight_attack_damage > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        self.delta_num_upgrades.knight_attack_damage = self.delta_num_upgrades.knight_attack_damage - 1
        self.knight.modifiers.attack_damage_num_upgrades = self.knight.modifiers.attack_damage_num_upgrades - 1
    end

    local can_buy = self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage < self.max_num_upgrades.knight_attack_damage
    imgui.set_state(can_buy and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        self.delta_num_upgrades.knight_attack_damage = self.delta_num_upgrades.knight_attack_damage + 1
        self.knight.modifiers.attack_damage_num_upgrades = self.knight.modifiers.attack_damage_num_upgrades + 1
    end

    imgui.set_state(imgui.GuiState.NORMAL)
end


function UpgradePanel:_render_attack_speed()
    local x, y = 50, 80
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Attack Speed: %.2f", self.knight:get_attack_speed()))

    local can_sell = self.delta_num_upgrades.knight_attack_speed > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        self.delta_num_upgrades.knight_attack_speed = self.delta_num_upgrades.knight_attack_speed - 1
        self.knight.modifiers.attack_speed_num_upgrades = self.knight.modifiers.attack_speed_num_upgrades - 1
    end

    local can_buy = self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed < self.max_num_upgrades.knight_attack_speed
    imgui.set_state(can_buy and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        self.delta_num_upgrades.knight_attack_speed = self.delta_num_upgrades.knight_attack_speed + 1
        self.knight.modifiers.attack_speed_num_upgrades = self.knight.modifiers.attack_speed_num_upgrades + 1
    end

    imgui.set_state(imgui.GuiState.NORMAL)
end


function UpgradePanel:_render_move_speed()
    local x, y = 50, 110
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Move Speed: %d", self.knight:get_move_speed()))

    local can_sell = self.delta_num_upgrades.knight_move_speed > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        self.delta_num_upgrades.knight_move_speed = self.delta_num_upgrades.knight_move_speed - 1
        self.knight.modifiers.move_speed_num_upgrades = self.knight.modifiers.move_speed_num_upgrades - 1
    end

    local can_buy = self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed < self.max_num_upgrades.knight_move_speed
    imgui.set_state(can_buy and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        self.delta_num_upgrades.knight_move_speed = self.delta_num_upgrades.knight_move_speed + 1
        self.knight.modifiers.move_speed_num_upgrades = self.knight.modifiers.move_speed_num_upgrades + 1
    end

    imgui.set_state(imgui.GuiState.NORMAL)
end


function UpgradePanel:_buy_button()
    local alignment_cache = imgui.get_style("button", "text_alignment")
    imgui.set_style("button", "text_alignment", imgui.GuiTextAlignment.CENTER)
    if imgui.button({x = (VirtualWidth - self.buy_text_width) / 2, y = VirtualHeight - 60 - 60, w = 2*self.buy_text_width, h = 30}, "BUY") then
        -- Notify Gameplay room that upgrade menu is done
        self.room.event_layer:notify(UpgradeRoomFinishedEvent())
    end
    imgui.set_style("button", "text_alignment", alignment_cache)
end


function UpgradePanel:destroy()
    self.room = nil
    self.knight = nil
    self.magic_shield = nil
end