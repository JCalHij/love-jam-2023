---@class PlayerControllerState: Object
local PlayerControllerState = Object:extend()

---@param controller PlayerController
function PlayerControllerState:new(controller)
    self.controller = controller
end

function PlayerControllerState:update(dt)
end



---@class IdleState: PlayerControllerState
local IdleState = PlayerControllerState:extend()

---@class OrderingKnightState: PlayerControllerState
local OrderingKnightState = PlayerControllerState:extend()



---@param controller PlayerController
function IdleState:new(controller)
    IdleState.super.new(self, controller)
end

function IdleState:update(dt)
    if input_is_mouse_pressed(EMouseButton.Left) then
        print("Going to OrderingKnightState")
        self.controller.state = OrderingKnightState(self.controller)
        self:destroy()
    end
end

function IdleState:destroy()
    self.controller = nil
end



---@param controller PlayerController
function OrderingKnightState:new(controller)
    OrderingKnightState.super.new(self, controller)
    self.targets = {}  ---@type Unit[]
    self.attack_chain = UnitChainEffect()
    self.controller.room:add_effect(self.attack_chain)
end

function OrderingKnightState:update(dt)
    if input_is_key_pressed("escape") then
        -- Cancel ordering, back to idle
        print("Cancelling order, going to IdleState")
        self.attack_chain:destroy()
        self.controller.state = IdleState(self.controller)
        self:destroy()
    elseif input_is_mouse_released(EMouseButton.Left) then
        -- Commit order to knight unit (only if targets locked) and back to idle
        print("Commiting order, going to IdleState")
        if #self.attack_chain.units > 0 then
            local targets_accepted = self.controller.room.knight:set_targets(self.attack_chain.units)
            if not targets_accepted then
                self.attack_chain:destroy()
            end
        else
            self.attack_chain:destroy()
        end
        self.controller.state = IdleState(self.controller)
        self:destroy()
    else
        -- Keep tracking enemy units
        -- Get enemy units under mouse
        local mouse_pos = screen_to_canvas(input_mouse_position())
        ---@param unit Unit
        local filter = function(unit)
            -- The unit class needs to be one of the following
            local valid_unit_classes = { NormalZombie, FastZombie, FatZombie }
            if table.ifind(valid_unit_classes, unit:class()) == nil then
                return false
            end
            -- The unit cannot be in the targets list
            if table.ifind(self.targets, unit) ~= nil then
                return false
            end
            -- The unit's position needs to be near the mouse
            local max_delta = 10
            local delta_pos = unit.pos - mouse_pos
            if delta_pos:len() > max_delta then
                return false
            end

            -- All checks passed
            return true
        end
        local filtered_units = self.controller.room:filter_units(filter)
        -- Add filtered units to the list, if any. Also, create trackers for each one
        -- and cache them
        if #filtered_units > 0 then
            for _, unit in ipairs(filtered_units) do
                table.insert(self.targets, unit)
                self.attack_chain:add_unit(unit)
            end
        end
    end
end

function OrderingKnightState:destroy()
    self.controller = nil
    self.targets = nil
    self.attack_chain = nil
end



-----------------------------------------------------------------------------------



---@class PlayerController: Object
---@operator call(): PlayerController
PlayerController = Object:extend()


---@param room GameplayRoom
function PlayerController:new(room)
    self.room = room
    self.state = IdleState(self)  ---@type PlayerControllerState
end


function PlayerController:update(dt)
    self.state:update(dt)
end


function PlayerController:destroy()
    self.room = nil
end