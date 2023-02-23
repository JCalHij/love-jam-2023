---@class UpgradePanel: Object
UpgradePanel = Object:extend()

local UpgradeCosts = {
    AttackDamage = {2, 4, 6},
    AttackSpeed = {1, 1, 1, 2, 2, 2, 3, 3, 3},
    MoveSpeed = {1, 1, 1, 1, 1, 2, 2, 2, 3},
    HpRecovery = 5,
    MagicShieldMaxHp = {3, 3, 3, 3, 3},
}


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
        magic_shield_max_hp = self.magic_shield.modifiers.max_hp_num_upgrades,
    }

    -- How many have we bought in the current upgrade session
    self.delta_num_upgrades = {
        knight_attack_damage = 0,
        knight_attack_speed = 0,
        knight_move_speed = 0,
        magic_shield_max_hp = 0,
    }

    -- Maximum amount of upgrades for each parameter
    self.max_num_upgrades = {
        knight_attack_damage = #UpgradeCosts.AttackDamage,
        knight_attack_speed = #UpgradeCosts.AttackSpeed,
        knight_move_speed = #UpgradeCosts.MoveSpeed,
        magic_shield_max_hp = #UpgradeCosts.MagicShieldMaxHp,
    }

    self.buy_text = "BUY"
    self.buy_text_width = love.graphics.getFont():getWidth(self.buy_text)*ScaleX
end


function UpgradePanel:render()
    imgui.panel({x = 30, y = 30, w = VirtualWidth-60, h = VirtualHeight-60}, "")

    self:_render_attack_damage()
    self:_render_attack_speed()
    self:_render_move_speed()
    self:_render_hp_recovery()
    self:_render_max_hp()

    self:_player_points()
    self:_buy_button()
end


function UpgradePanel:_render_attack_damage()
    local x, y = 50, 50
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Attack Damage: %d", self.knight:get_attack_damage()))

    -- Sell

    local can_sell = self.delta_num_upgrades.knight_attack_damage > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        -- Update points
        local index_to_recover = self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage
        self.room.player_points = self.room.player_points + UpgradeCosts.AttackDamage[index_to_recover]
        -- Update player
        self.delta_num_upgrades.knight_attack_damage = self.delta_num_upgrades.knight_attack_damage - 1
        self.knight.modifiers.attack_damage_num_upgrades = self.knight.modifiers.attack_damage_num_upgrades - 1
    end

    -- Buy

    imgui.set_state(self:_can_purchase_attack_damage() and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        -- Update player
        self.delta_num_upgrades.knight_attack_damage = self.delta_num_upgrades.knight_attack_damage + 1
        self.knight.modifiers.attack_damage_num_upgrades = self.knight.modifiers.attack_damage_num_upgrades + 1
        -- Update points
        local index_to_purchase = self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage
        self.room.player_points = self.room.player_points - UpgradeCosts.AttackDamage[index_to_purchase]
    end

    -- Next cost

    imgui.set_state(imgui.GuiState.NORMAL)
    do
        local label_rect = {x = x + 375, y = y, w = 25, h = 25}
        if not self:_max_attack_damage_reached() then
            local index_to_purchase = self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage + 1
            local cost = UpgradeCosts.AttackDamage[index_to_purchase]
            imgui.label(label_rect, string.format("Next: %d", cost))
        else
            imgui.label(label_rect, "MAX RANK")
        end
    end
end


function UpgradePanel:_render_attack_speed()
    local x, y = 50, 80
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Attack Speed: %.2f", self.knight:get_attack_speed()))

    -- Sell

    local can_sell = self.delta_num_upgrades.knight_attack_speed > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        -- Update points
        local index_to_recover = self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed
        self.room.player_points = self.room.player_points + UpgradeCosts.AttackSpeed[index_to_recover]
        -- Update player
        self.delta_num_upgrades.knight_attack_speed = self.delta_num_upgrades.knight_attack_speed - 1
        self.knight.modifiers.attack_speed_num_upgrades = self.knight.modifiers.attack_speed_num_upgrades - 1
    end

    -- Buy

    imgui.set_state(self:_can_purchase_attack_speed() and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        -- Update player
        self.delta_num_upgrades.knight_attack_speed = self.delta_num_upgrades.knight_attack_speed + 1
        self.knight.modifiers.attack_speed_num_upgrades = self.knight.modifiers.attack_speed_num_upgrades + 1
        -- Update points
        local index_to_purchase = self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed
        self.room.player_points = self.room.player_points - UpgradeCosts.AttackSpeed[index_to_purchase]
    end

    -- Next cost

    imgui.set_state(imgui.GuiState.NORMAL)
    do
        local label_rect = {x = x + 375, y = y, w = 25, h = 25}
        if not self:_max_attack_speed_reached() then
            local index_to_purchase = self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed + 1
            local cost = UpgradeCosts.AttackSpeed[index_to_purchase]
            imgui.label(label_rect, string.format("Next: %d", cost))
        else
            imgui.label(label_rect, "MAX RANK")
        end
    end
end


function UpgradePanel:_render_move_speed()
    local x, y = 50, 110
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Knight Move Speed: %d", self.knight:get_move_speed()))

    -- Sell

    local can_sell = self.delta_num_upgrades.knight_move_speed > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        -- Update points
        local index_to_recover = self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed
        self.room.player_points = self.room.player_points + UpgradeCosts.MoveSpeed[index_to_recover]
        -- Update player
        self.delta_num_upgrades.knight_move_speed = self.delta_num_upgrades.knight_move_speed - 1
        self.knight.modifiers.move_speed_num_upgrades = self.knight.modifiers.move_speed_num_upgrades - 1
    end

    -- Buy

    imgui.set_state(self:_can_purchase_move_speed() and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        -- Update player
        self.delta_num_upgrades.knight_move_speed = self.delta_num_upgrades.knight_move_speed + 1
        self.knight.modifiers.move_speed_num_upgrades = self.knight.modifiers.move_speed_num_upgrades + 1
        -- Update points
        local index_to_purchase = self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed
        self.room.player_points = self.room.player_points - UpgradeCosts.MoveSpeed[index_to_purchase]
    end

    -- Next cost

    imgui.set_state(imgui.GuiState.NORMAL)
    do
        local label_rect = {x = x + 375, y = y, w = 25, h = 25}
        if not self:_max_move_speed_reached() then
            local index_to_purchase = self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed + 1
            local cost = UpgradeCosts.MoveSpeed[index_to_purchase]
            imgui.label(label_rect, string.format("Next: %d", cost))
        else
            imgui.label(label_rect, "MAX RANK")
        end
    end
end


function UpgradePanel:_render_hp_recovery()
    local x, y = 50, 140
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Magic Shield HP: %d / %d", self.magic_shield.hp, self.magic_shield:get_max_hp()))

    -- Buy

    imgui.set_state(self:_can_purchase_hp_recovery() and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 100, h = 25}, "Recover") then
        -- Update magic shield
        self.magic_shield.hp = self.magic_shield.hp + 1
        -- Update points
        self.room.player_points = self.room.player_points - UpgradeCosts.HpRecovery
    end

    -- Next cost

    imgui.set_state(imgui.GuiState.NORMAL)
    do
        local label_rect = {x = x + 402, y = y, w = 25, h = 25}
        if not self:_max_hp_reached() then
            local cost = UpgradeCosts.HpRecovery
            imgui.label(label_rect, string.format("Cost: %d", cost))
        end
    end
end


function UpgradePanel:_render_max_hp()
    local x, y = 50, 170
    imgui.label({x = x, y = y, w = 300, h = 25}, string.format("Magic Shield Max HP: %d", self.magic_shield:get_max_hp()))

    -- Sell

    local can_sell = self.delta_num_upgrades.magic_shield_max_hp > 0
    imgui.set_state(can_sell and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 300, y = y, w = 25, h = 25}, "-") then
        -- Update points
        local index_to_recover = self.delta_num_upgrades.magic_shield_max_hp + self.current_num_upgrades.magic_shield_max_hp
        self.room.player_points = self.room.player_points + UpgradeCosts.MagicShieldMaxHp[index_to_recover]
        -- Update magic shield
        self.delta_num_upgrades.magic_shield_max_hp = self.delta_num_upgrades.magic_shield_max_hp - 1
        self.magic_shield.modifiers.max_hp_num_upgrades = self.magic_shield.modifiers.max_hp_num_upgrades - 1
    end

    -- Buy

    imgui.set_state(self:_can_purchase_max_hp() and imgui.GuiState.NORMAL or imgui.GuiState.DISABLED)
    if imgui.button({x = x + 325, y = y, w = 25, h = 25}, "+") then
        -- Update magic shield
        self.delta_num_upgrades.magic_shield_max_hp = self.delta_num_upgrades.magic_shield_max_hp + 1
        self.magic_shield.modifiers.max_hp_num_upgrades = self.magic_shield.modifiers.max_hp_num_upgrades + 1
        -- Update points
        local index_to_purchase = self.delta_num_upgrades.magic_shield_max_hp + self.current_num_upgrades.magic_shield_max_hp
        self.room.player_points = self.room.player_points - UpgradeCosts.MagicShieldMaxHp[index_to_purchase]
    end

    -- Next cost

    imgui.set_state(imgui.GuiState.NORMAL)
    do
        local label_rect = {x = x + 375, y = y, w = 25, h = 25}
        if not self:_max_maxhp_reached() then
            local index_to_purchase = self.delta_num_upgrades.magic_shield_max_hp + self.current_num_upgrades.magic_shield_max_hp + 1
            local cost = UpgradeCosts.MagicShieldMaxHp[index_to_purchase]
            imgui.label(label_rect, string.format("Next: %d", cost))
        else
            imgui.label(label_rect, "MAX RANK")
        end
    end
end


function UpgradePanel:_player_points()
    imgui.label({x = (VirtualWidth - self.buy_text_width) / 2, y = VirtualHeight - 60 - 120, w = 2*self.buy_text_width, h = 30}, string.format("%d", self.room.player_points))
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


function UpgradePanel:_can_purchase_attack_damage()
    -- Max upgrade reached
    if self:_max_attack_damage_reached() then
        return false
    end
    -- Not enough points. No need for bounds checking, as we are not at max upgrade (checked before)
    local index_to_purchase = self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage + 1
    if self.room.player_points < UpgradeCosts.AttackDamage[index_to_purchase] then
        return false
    end
    -- All OK, can purchase
    return true
end


function UpgradePanel:_can_purchase_attack_speed()
    -- Max upgrade reached
    if self:_max_attack_speed_reached() then
        return false
    end
    -- Not enough points. No need for bounds checking, as we are not at max upgrade (checked before)
    local index_to_purchase = self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed + 1
    if self.room.player_points < UpgradeCosts.AttackSpeed[index_to_purchase] then
        return false
    end
    -- All OK, can purchase
    return true
end


function UpgradePanel:_can_purchase_move_speed()
    -- Max upgrade reached
    if self:_max_move_speed_reached() then
        return false
    end
    -- Not enough points. No need for bounds checking, as we are not at max upgrade (checked before)
    local index_to_purchase = self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed + 1
    if self.room.player_points < UpgradeCosts.MoveSpeed[index_to_purchase] then
        return false
    end
    -- All OK, can purchase
    return true
end


function UpgradePanel:_can_purchase_hp_recovery()
    -- Max upgrade reached
    if self:_max_hp_reached() then
        return false
    end
    -- Not enough points. No need for bounds checking, as we are not at max upgrade (checked before)
    if self.room.player_points < UpgradeCosts.HpRecovery then
        return false
    end
    -- All OK, can purchase
    return true
end


function UpgradePanel:_can_purchase_max_hp()
    -- Max upgrade reached
    if self:_max_maxhp_reached() then
        return false
    end
    -- Not enough points. No need for bounds checking, as we are not at max upgrade (checked before)
    local index_to_purchase = self.delta_num_upgrades.magic_shield_max_hp + self.current_num_upgrades.magic_shield_max_hp + 1
    if self.room.player_points < UpgradeCosts.MagicShieldMaxHp[index_to_purchase] then
        return false
    end
    -- All OK, can purchase
    return true
end


function UpgradePanel:_max_attack_damage_reached()
    return (self.delta_num_upgrades.knight_attack_damage + self.current_num_upgrades.knight_attack_damage) >= self.max_num_upgrades.knight_attack_damage
end


function UpgradePanel:_max_attack_speed_reached()
    return (self.delta_num_upgrades.knight_attack_speed + self.current_num_upgrades.knight_attack_speed) >= self.max_num_upgrades.knight_attack_speed
end


function UpgradePanel:_max_move_speed_reached()
    return (self.delta_num_upgrades.knight_move_speed + self.current_num_upgrades.knight_move_speed) >= self.max_num_upgrades.knight_move_speed
end


function UpgradePanel:_max_hp_reached()
    return self.magic_shield.hp == self.magic_shield:get_max_hp()
end


function UpgradePanel:_max_maxhp_reached()
    return (self.delta_num_upgrades.magic_shield_max_hp + self.current_num_upgrades.magic_shield_max_hp) >= self.max_num_upgrades.magic_shield_max_hp
end


function UpgradePanel:destroy()
    self.room = nil
    self.knight = nil
    self.magic_shield = nil
end