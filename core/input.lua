--
-- Module State
--

local KeysPressed = {}
local KeysReleased = {}
local KeysHeld = {}

local MousePressed = {}
local MouseReleased = {}
local MouseHeld = {}
local MousePos = Vector2(0, 0)
local MouseDelta = Vector2(0, 0)
local MouseMoved = false
local MouseWheel = Vector2(0, 0)

local GamepadPressed = {}
local GamepadReleased = {}
local GamepadHeld = {}
local GamepadAxis = {}


local ActionsPressed = {}
local ActionsReleased = {}
local ActionsHeld = {}

-- The input mapping from keyboard to actions.
local KeyboardToActions = {}
-- The input mapping from gamepad to actions.
local GamepadToActions = {}

--[[
The input scheme currently being used to map actions to OS events.

It is a list of action names, which are dictionaries that map
the input method being used (e.g., keyboard, gamepad) to the
key code for that given action. Multiple keys can be assigned
to a single action.

An example for the `ui_accept` action can be found below.

```lua
InputScheme = {
    ["ui_accept"] = {
        keyboard = {"return",},
        gamepad = {"a",},
    }
}
```
]]
local InputScheme = {}


--
-- Constants
--

--[[
List of key constants, as specified under https://love2d.org/wiki/KeyConstant
]]
local KeyConstants = {
    -- Characters
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "space", "!", '"', "#", "$", "&", "'", "(", ")",
    "*", "+", ",", "-", ".", "/", ":", ";", "<", "=",
    ">", "?", "@", "[", "\\", "]", "^", "_", "`",
    -- Numpad
    "kp0", "kp1", "kp2", "kp3", "kp4", "kp5", "kp6",
    "kp7", "kp8", "kp9", "kp.", "kp,", "kp/", "kp*",
    "kp-", "kp+", "kpenter", "kp=",
    -- Navigation
    "up", "down", "left", "right", "home", "end", "pageup",
    "pagedown",
    -- Editing
    "insert", "backspace", "tab", "clear", "return", "delete",
    -- Functions
    "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9",
    "f10", "f11", "f12", "f13", "f14", "f15", "f16", "f17",
    "f18",
    -- Modifiers
    "numlock", "capslock", "scrolllock", "rshift", "lshift",
    "rctrl", "lctrl", "ralt", "lalt", "rgui", "lgui", "mode",
    -- Miscellaneous
    "pause", "escape", "help", "printscreen", "sysreq", "menu",
    "application", "power", "currencyunit", "undo",
}

--[[
List of gamepad button constans, as specified under https://love2d.org/wiki/GamepadButton
]]
local GamepadButtonConstants = {
    "a", "b", "x", "y",
    "back", "guide", "start",
    "leftstick", "rightstick", "leftshoulder", "rightshoulder",
    "dpup", "dpdown", "dpleft", "dpright",
}

--[[
List of gamepad axis constans, as specified under https://love2d.org/wiki/GamepadAxis
]]
local GamepadAxisConstants = {
    "leftx", "lefty",
    "rightx", "righty",
    "triggerleft", "triggerright",
}


--
-- Init Module
--

--[[
Initializes the input module. Must be called during 'love.load'.
]]
function input_init()
    for _, axis in ipairs(GamepadAxisConstants) do
        GamepadAxis[axis] = 0
    end

    -- Override any Löve2D callback listeners
    local callbacks = {'keypressed', 'keyreleased', 'mousepressed', 'mousereleased', 'mousemoved', 'wheelmoved', 'gamepadpressed', 'gamepadreleased', 'gamepadaxis'}
    local empty_function = function(...) end
    for _, f in ipairs(callbacks) do
        local old_f = love[f] or empty_function
        love[f] = function(...)
            old_f(...)
            _G["input_" .. f](...)
        end
    end
end

--[[
Clears the state of all pressed and released states and actions. 
Held states/actions are kept in between frames, so long as the 
`release` call is not called.

Used at the end of the main loop to clear the module.
]]
function input_cleanup_frame()
    -- Keyboard
    KeysPressed = {}
    KeysReleased = {}
    -- Gamepad
    GamepadPressed = {}
    GamepadReleased = {}
    -- Mouse
    MousePressed = {}
    MouseReleased = {}
    MouseMoved = false
    MouseDelta = Vector2(0, 0)
    MouseWheel = Vector2(0, 0)
    -- Actions
    ActionsPressed = {}
    ActionsReleased = {}
end


--
-- Callbacks
--

--[[
Callback function that is called from the framework itself.
]]
---@param key string
---@param scancode string
---@param isrepeat boolean
function input_keypressed(key, scancode, isrepeat)
    -- Key setup
    KeysPressed[key] = true
    KeysHeld[key] = true
    KeysReleased[key] = false
    -- Action setup
    for k, action in pairs(KeyboardToActions) do
        if k == key then
            ActionsPressed[action] = true
            ActionsHeld[action] = true
            ActionsReleased[action] = false
            break
        end
    end
end

--[[
Callback function that is called from the framework itself.
]]
---@param key string
---@param scancode string
---@param isrepeat boolean
function input_keyreleased(key, scancode, isrepeat)
    -- Key setup
    KeysPressed[key] = false
    KeysHeld[key] = false
    KeysReleased[key] = true
    -- Action setup
    for k, action in pairs(KeyboardToActions) do
        if k == key then
            ActionsPressed[action] = false
            ActionsHeld[action] = false
            ActionsReleased[action] = true
            break
        end
    end
end

--[[
Callback function that is called from the framework itself.
]]
---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function input_mousepressed(x, y, button, istouch, presses)
    MousePressed[button] = true
    MouseHeld[button] = true
    MouseReleased[button] = false
end

--[[
Callback function that is called from the framework itself.
]]
---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function input_mousereleased(x, y, button, istouch, presses)
    MousePressed[button] = false
    MouseHeld[button] = false
    MouseReleased[button] = true
end

--[[
Callback function that is called from the framework itself.
]]
---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function input_mousemoved(x, y, dx, dy, istouch)
    MousePos = Vector2(x, y)
    MouseDelta = Vector2(dx, dy)
    MouseMoved = true
end

--[[
Callback function that is called from the framework itself.
]]
---@param x number
---@param y number
function input_wheelmoved(x, y)
    MouseWheel = Vector2(x, y)
end

--[[
Callback function that is called from the framework itself.
]]
---@param joystick userdata
---@param button string
function input_gamepadpressed(joystick, button)
    -- Key setup
    GamepadPressed[button] = true
    GamepadHeld[button] = true
    GamepadReleased[button] = false
    -- Action setup
    for b, action in pairs(GamepadToActions) do
        if b == button then
            ActionsPressed[action] = true
            ActionsHeld[action] = true
            ActionsReleased[action] = false
            break
        end
    end
end

--[[
Callback function that is called from the framework itself.
]]
---@param joystick userdata
---@param button string
function input_gamepadreleased(joystick, button)
    -- Key setup
    GamepadPressed[button] = true
    GamepadHeld[button] = true
    GamepadReleased[button] = false
    -- Action setup
    for b, action in pairs(GamepadToActions) do
        if b == button then
            ActionsPressed[action] = false
            ActionsHeld[action] = false
            ActionsReleased[action] = true
            break
        end
    end
end

--[[
Callback function that is called from the framework itself.
]]
---@param joystick userdata
---@param axis string
---@param value number
function input_gamepadaxis(joystick, axis, value)
    GamepadAxis[axis] = value
end


--
-- Input requests
--

--[[
Returns whether the key has been pressed in the current frame
]]
---@param key string
---@return boolean
function input_is_key_pressed(key)
    return KeysPressed[key]
end

--[[
Returns whether the key is currently being pressed in the current frame
]]
---@param key string
---@return boolean
function input_is_key_held(key)
    return KeysHeld[key]
end

--[[
Returns whether the key has been released in the current frame
]]
---@param key string
---@return boolean
function input_is_key_released(key)
    return KeysReleased[key]
end

--[[
Returns whether the mouse button has been pressed in the current frame
]]
---@param button number
---@return boolean
function input_is_mouse_pressed(button)
    return MousePressed[button]
end

--[[
Returns whether the mouse button is being pressed in the current frame
]]
---@param button number
---@return boolean
function input_is_mouse_held(button)
    return MouseHeld[button]
end

--[[
Returns whether the mouse button has been released in the current frame
]]
---@param button number
---@return boolean
function input_is_mouse_released(button)
    return MouseReleased[button]
end

--[[
Returns whether the gamepad button has been pressed in the current frame
]]
---@param button number
---@return boolean
function input_is_gamepad_pressed(button)
    return GamepadPressed[button]
end

--[[
Returns whether the gamepad button is being pressed in the current frame
]]
---@param button number
---@return boolean
function input_is_gamepad_held(button)
    return GamepadHeld[button]
end

--[[
Returns whether the gamepad button has been released in the current frame
]]
---@param button number
---@return boolean
function input_is_gamepad_released(button)
    return GamepadReleased[button]
end

--[[
Returns the state of the left gamepad axis as a tuple (x, y).
]]
---@return table
function input_get_gamepad_left_axis()
    return { GamepadAxis.leftx, GamepadAxis.lefty }
end

--[[
Returns the state of the right gamepad axis as a tuple (x, y).
]]
---@return table
function input_get_gamepad_right_axis()
    return { GamepadAxis.rightx, GamepadAxis.righty }
end

--[[
Returns whether the action has been pressed in the current frame
]]
---@param action string
---@return boolean
function input_is_action_pressed(action)
    return ActionsPressed[action]
end

--[[
Returns whether the action is currently being pressed in the current frame
]]
---@param action string
---@return boolean
function input_is_action_held(action)
    return ActionsHeld[action]
end

--[[
Returns whether the action has been released in the current frame
]]
---@param action string
---@return boolean
function input_is_action_released(action)
    return ActionsReleased[action]
end

--[[
Sets the currently used `InputScheme` to the one provided. For insight 
on the structure of the `InputScheme` object, check out its documentation.
]]
---@param input_scheme table
function input_set_scheme(input_scheme)
    InputScheme = input_scheme
    KeyboardToActions = {}
    GamepadToActions = {}
    for action, mappings in pairs(input_scheme) do
        -- Keyboard to Actions
        if mappings.keyboard then
            for i, key in ipairs(mappings.keyboard) do
                KeyboardToActions[key] = action
            end
        end
        -- Gamepad to Actions
        if mappings.gamepad then
            for i, key in ipairs(mappings.gamepad) do
                GamepadToActions[key] = action
            end
        end
    end

    ActionsPressed = {}
    ActionsHeld = {}
    ActionsReleased = {}
end

--[[
Returns if mouse moved during the current frame.
]]
---@return boolean
function input_mouse_moved()
    return MouseMoved
end

--[[
Returns the mouse position in screen coordinates, as a Vector2.
]]
---@return Vec2
function input_mouse_position()
    return MousePos
end

--[[
Returns the mouse movement for the current frame, as a Vector2.
]]
---@return Vec2
function input_mouse_delta()
    return MouseDelta
end

--[[
Returns the mouse wheel movement for the current frame, as a Vector2.
]]
---@return Vec2
function input_mouse_wheel()
    return MouseWheel
end
