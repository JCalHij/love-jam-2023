--[[
Module based on raygui implementation, version 3.2.

https://github.com/raysan5/raygui

The following is the exposed raygui API, and will be used to track the implementation
of this module.


    // Global gui state control functions
    - [x] RAYGUIAPI void GuiEnable(void);                                         // Enable gui controls (global state)
    - [x] RAYGUIAPI void GuiDisable(void);                                        // Disable gui controls (global state)
    - [x] RAYGUIAPI void GuiLock(void);                                           // Lock gui controls (global state)
    - [x] RAYGUIAPI void GuiUnlock(void);                                         // Unlock gui controls (global state)
    - [x] RAYGUIAPI bool GuiIsLocked(void);                                       // Check if gui is locked (global state)
    - [x] RAYGUIAPI void GuiFade(float alpha);                                    // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
    - [x] RAYGUIAPI void GuiSetState(int state);                                  // Set gui state (global state)
    - [x] RAYGUIAPI int GuiGetState(void);                                        // Get gui state (global state)

    // Font set/get functions
    - [x] RAYGUIAPI void GuiSetFont(Font font);                                   // Set gui custom font (global state)
    - [x] RAYGUIAPI Font GuiGetFont(void);                                        // Get gui custom font (global state)

    // Style set/get functions
    - [x] RAYGUIAPI void GuiSetStyle(int control, int property, int value);       // Set one style property
    - [x] RAYGUIAPI int GuiGetStyle(int control, int property);                   // Get one style property

    // Container/separator controls, useful for controls organization
    - [x] RAYGUIAPI bool GuiWindowBox(Rectangle bounds, const char *title);                                       // Window Box control, shows a window that can be closed
    - [ ] RAYGUIAPI void GuiGroupBox(Rectangle bounds, const char *text);                                         // Group Box control with text name
    - [x] RAYGUIAPI void GuiLine(Rectangle bounds, const char *text);                                             // Line separator control, could contain text
    - [x] RAYGUIAPI void GuiPanel(Rectangle bounds, const char *text);                                            // Panel control, useful to group controls
    - [x] RAYGUIAPI Rectangle GuiScrollPanel(Rectangle bounds, const char *text, Rectangle content, Vector2 *scroll); // Scroll Panel control

    // Basic controls set
    - [x] API void GuiLabel(Rectangle bounds, const char *text);                                            // Label control, shows text
    - [x] API bool GuiButton(Rectangle bounds, const char *text);                                           // Button control, returns true when clicked
    - [x] API bool GuiLabelButton(Rectangle bounds, const char *text);                                      // Label button control, show true when clicked
    - [x] API bool GuiToggle(Rectangle bounds, const char *text, bool active);                              // Toggle Button control, returns true when active
    - [x] API int GuiToggleGroup(Rectangle bounds, const char *text, int active);                           // Toggle Group control, returns active toggle index
    - [x] API bool GuiCheckBox(Rectangle bounds, const char *text, bool checked);                           // Check Box control, returns true when active
    - [x] API int GuiComboBox(Rectangle bounds, const char *text, int active);                              // Combo Box control, returns selected item index
    - [x] API bool GuiDropdownBox(Rectangle bounds, const char *text, int *active, bool editMode);          // Dropdown Box control, returns selected item
    - [x] API bool GuiSpinner(Rectangle bounds, const char *text, int *value, int minValue, int maxValue, bool editMode);     // Spinner control, returns selected value
    - [x] API bool GuiValueBox(Rectangle bounds, const char *text, int *value, int minValue, int maxValue, bool editMode);    // Value Box control, updates input text with numbers
    - [x] API bool GuiTextBox(Rectangle bounds, char *text, int textSize, bool editMode);                   // Text Box control, updates input text
    - [x] API bool GuiTextBoxMulti(Rectangle bounds, char *text, int textSize, bool editMode);              // Text Box control with multiple lines
    - [ ] API float GuiSlider(Rectangle bounds, const char *textLeft, const char *textRight, float value, float minValue, float maxValue);       // Slider control, returns selected value
    - [ ] API float GuiSliderBar(Rectangle bounds, const char *textLeft, const char *textRight, float value, float minValue, float maxValue);    // Slider Bar control, returns selected value
    - [ ] API float GuiProgressBar(Rectangle bounds, const char *textLeft, const char *textRight, float value, float minValue, float maxValue);  // Progress Bar control, shows current progress value
    - [x] API void GuiStatusBar(Rectangle bounds, const char *text);                                        // Status Bar control, shows info text
    - [x] API void GuiDummyRec(Rectangle bounds, const char *text);                                         // Dummy control for placeholders
    - [ ] API Vector2 GuiGrid(Rectangle bounds, const char *text, float spacing, int subdivs);              // Grid control, returns mouse cell position

    // Advance controls set
    - [ ] RAYGUIAPI int GuiListView(Rectangle bounds, const char *text, int *scrollIndex, int active);            // List View control, returns selected list item index
    - [ ] RAYGUIAPI int GuiListViewEx(Rectangle bounds, const char **text, int count, int *focus, int *scrollIndex, int active);      // List View with extended parameters
    - [ ] RAYGUIAPI int GuiMessageBox(Rectangle bounds, const char *title, const char *message, const char *buttons);                 // Message Box control, displays a message
    - [ ] RAYGUIAPI int GuiTextInputBox(Rectangle bounds, const char *title, const char *message, const char *buttons, char *text, int textMaxSize, int *secretViewActive);   // Text Input Box control, ask for text, supports secret
    - [ ] RAYGUIAPI Color GuiColorPicker(Rectangle bounds, const char *text, Color color);                        // Color Picker control (multiple color controls)
    - [ ] RAYGUIAPI Color GuiColorPanel(Rectangle bounds, const char *text, Color color);                         // Color Panel control
    - [ ] RAYGUIAPI float GuiColorBarAlpha(Rectangle bounds, const char *text, float alpha);                      // Color Bar Alpha control
    - [ ] RAYGUIAPI float GuiColorBarHue(Rectangle bounds, const char *text, float value);                        // Color Bar Hue control

    // Styles loading functions
    - [ ] RAYGUIAPI void GuiLoadStyle(const char *fileName);              // Load style file over global style variable (.rgs)
    - [x] RAYGUIAPI void GuiLoadStyleDefault(void);                       // Load style default over global style

    // Icons functionality
    - [ ] RAYGUIAPI const char *GuiIconText(int iconId, const char *text); // Get text with icon id prepended (if supported)

    #if !defined(RAYGUI_NO_ICONS)
    - [ ] RAYGUIAPI void GuiDrawIcon(int iconId, int posX, int posY, int pixelSize, Color color);

    - [ ] RAYGUIAPI unsigned int *GuiGetIcons(void);                      // Get full icons data pointer
    - [ ] RAYGUIAPI unsigned int *GuiGetIconData(int iconId);             // Get icon bit data
    - [ ] RAYGUIAPI void GuiSetIconData(int iconId, unsigned int *data);  // Set icon bit data
    - [ ] RAYGUIAPI void GuiSetIconScale(unsigned int scale);             // Set icon scale (1 by default)

    - [ ] RAYGUIAPI void GuiSetIconPixel(int iconId, int x, int y);       // Set icon pixel value
    - [ ] RAYGUIAPI void GuiClearIconPixel(int iconId, int x, int y);     // Clear icon pixel value
    - [ ] RAYGUIAPI bool GuiCheckIconPixel(int iconId, int x, int y);     // Check icon pixel value
]]
imgui = {}


--[[

]]
---@enum GuiState
imgui.GuiState = {
    NORMAL = 0,
    FOCUSED = 1,
    PRESSED = 2,
    DISABLED = 3,
}


--[[

]]
---@enum GuiTextAlignment
imgui.GuiTextAlignment = {
    LEFT = 0,
    CENTER = 1,
    RIGHT = 2,
}


--[[

]]
---@enum ScrollBarSide
imgui.ScrollBarSide = {
    LEFT = 0,
    RIGHT = 1,
}

---@alias ControlType
---| "default"
---| "label"
---| "button"
---| "toggle"
---| "slider"
---| "progressbar"
---| "checkbox"
---| "combobox"
---| "dropdownbox"
---| "textbox"
---| "valuebox"
---| "spinner"
---| "listview"
---| "colorpicker"
---| "scrollbar"
---| "statusbar"

---@alias ControlProperty
---| "border_color_normal"
---| "base_color_normal"
---| "text_color_normal"
---| "border_color_focused"
---| "base_color_focused"
---| "text_color_focused"
---| "border_color_pressed"
---| "base_color_pressed"
---| "text_color_pressed"
---| "border_color_disabled"
---| "base_color_disabled"
---| "text_color_disabled"
---| "border_width"
---| "text_padding"
---| "text_alignment"
---| "reserved"
---| "text_size"
---| "text_spacing"
---| "line_color"
---| "background_color"
---| "group_padding"
---| "slider_width"
---| "slider_padding"
---| "progress_padding"
---| "check_padding"
---| "combo_button_width"
---| "combo_button_spacing"
---| "arrow_padding"
---| "dropdown_items_spacing"
---| "text_inner_padding"
---| "text_lines_spacing"
---| "spin_button_width"
---| "spin_button_spacing"
---| "list_items_height"
---| "list_items_spacing"
---| "scrollbar_width"
---| "scrollbar_side"
---| "color_selector_size"
---| "huebar_width"
---| "huebar_padding"
---| "huebar_selector_height"
---| "huebar_selector_overflow"
---| "arrows_size"
---| "arrows_visible"
---| "scroll_slider_padding"
---| "scroll_slider_size"
---| "scroll_padding"
---| "scroll_speed"

---@type { [ControlType]: {[ControlProperty]: integer}}
local default_style = {
    -- Populates all controls when set
    default = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        text_size = 0,
        text_spacing = 0,
        line_color = 0,
        background_color = 0,
    },
    -- Basic controls
    -- label button
    label = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
    },
    button = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
    },
    -- togglegroup
    toggle = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        group_padding = 0,
    },
    -- sliderbar
    slider = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        slider_width = 0,
        slider_padding = 0,
    },
    progressbar = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        progress_padding = 0,
    },
    checkbox = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        check_padding = 0,
    },
    combobox = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        combo_button_width = 0,
        combo_button_spacing = 0,
    },
    dropdownbox = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        arrow_padding = 0,
        dropdown_items_spacing = 0,
    },
    -- textboxmulti
    textbox = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        text_inner_padding = 0,
        text_lines_spacing = 0,
    },
    valuebox = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
    },
    -- uses button, valuebox
    spinner = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        spin_button_width = 0,
        spin_button_spacing = 0,
    },
    listview = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        list_items_height = 0,
        list_items_spacing = 0,
        scrollbar_width = 0,
        scrollbar_side = 0,
    },
    colorpicker = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        color_selector_size = 0,
        huebar_width = 0,
        huebar_padding = 0,
        huebar_selector_height = 0,
        huebar_selector_overflow = 0,
    },
    scrollbar = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
        -- extended
        arrows_size = 0,
        arrows_visible = 0,
        scroll_slider_padding = 0,
        scroll_slider_size = 0,
        scroll_padding = 0,
        scroll_speed = 0,
    },
    statusbar = {
        border_color_normal = 0,
        base_color_normal = 0,
        text_color_normal = 0,
        border_color_focused = 0,
        base_color_focused = 0,
        text_color_focused = 0,
        border_color_pressed = 0,
        base_color_pressed = 0,
        text_color_pressed = 0,
        border_color_disabled = 0,
        base_color_disabled = 0,
        text_color_disabled = 0,
        border_width = 0,
        text_padding = 0,
        text_alignment = 0,
        reserved = 0,
    },
}

local default_font = love.graphics.newFont(22, "normal")

local WINDOWBOX_STATUSBAR_HEIGHT = 24
local PANEL_BORDER_WIDTH = 1
local LINE_MARGIN_TEXT = 12
local LINE_TEXT_PADDING = 4
local BLANK = {0, 0, 0, 0} -- //TODO[javi]: raygui does not define this unless raylib.h is included
local LEFT_MOUSE_BUTTON = Constants.MouseKeys.LEFT_BUTTON


--[[
The global state of the module. Not exposed, only modifyable via
API.
]]
local g_state = {
    ---@type GuiState
    state = imgui.GuiState.NORMAL,
    ---@type userdata
    font = default_font,
    ---@type boolean
    locked = false,
    ---@type number
    alpha = 1.0,
    ---@type table
    style = table.deepcopy(default_style),
    ---@type string
    key_pressed = "",
    ---@type string
    textinput_pressed = "",
}


---@param rect Rectangle
---@param border_width number
---@param border_color Color
---@param color Color
local function draw_rectangle(rect, border_width, border_color, color)
    -- Fill
    SetDrawColor(color)
    DrawRectangle(rect)
    -- Border
    if border_width > 0 then
        SetDrawColor(border_color)
        DrawRectangleLines(rect)
    end
    SetDrawColor({1,1,1,1})
end


---@param text string
---@param bounds Rectangle
---@param alignment GuiTextAlignment
---@param tint Color
local function draw_text(text, bounds, alignment, tint)
    local position = nil
    local text_size = {
        w = g_state.font:getWidth(text),
        h = g_state.font:getHeight(),
    }
    if alignment == imgui.GuiTextAlignment.LEFT then
        position = {
            x = bounds.x,
            y = bounds.y + bounds.h/2 - text_size.h/2 + bounds.h%2
        }
    elseif alignment == imgui.GuiTextAlignment.CENTER then
        position = {
            x = bounds.x + bounds.w/2 - text_size.w/2,
            y = bounds.y + bounds.h/2 - text_size.h/2 + bounds.h%2
        }
    elseif alignment == imgui.GuiTextAlignment.RIGHT then
        position = {
            x = bounds.x + bounds.w - text_size.w,
            y = bounds.y + bounds.h/2 - text_size.h/2 + bounds.h%2
        }
    end
    love.graphics.print({tint, text}, g_state.font, position.x, position.y)
end


--[[
Transforms given color `color` into a table-formatted color.

Input is an 32-bit integer value, in which each byte represents
each of the channels.

Returns an indexed table.

Example:

    local color = 0x112233FF
    local color_table = get_color(color) -- color_table = {0x11/255, 0x22/255, 0x33/255, 1.0}
]]
---@param color integer
---@return Color
local function get_color(color)
    return {
        bit.band(bit.rshift(color, 24), 0xFF) / 255,
        bit.band(bit.rshift(color, 16), 0xFF) / 255,
        bit.band(bit.rshift(color, 8), 0xFF) / 255,
        bit.band(color, 0xFF) / 255,
    }
end


--[[
Transforms given color `color`'s alpha channel into
value given by `alpha`. `alpha` is clamped in the 
range [0, 1]. Returns the transformed color.

Example:

    local color = {0.3, 1.0, 0.4, 1.0} -- {Red, Green, Blue, Alpha}
    local new_color = fade(color, 0.5) -- new_color = {0.3, 1.0, 0.4, 0.5}
]]
---comment
---@param color Color
---@param alpha number
---@return Color
local function fade(color, alpha)
    local a = math.max(0, math.min(1, alpha))
    return {
        color[1], color[2], color[3], a
    }
end


--[[

]]
---@param control ControlType
---@param property ControlProperty
---@return Color
local function get_faded_color(control, property)
    return fade(get_color(imgui.get_style(control, property)), g_state.alpha)
end


---@param control ControlType
---@param bounds Rectangle
---@return Rectangle
local function text_bounds(control, bounds)
    local border_width = imgui.get_style(control, "border_width")
    local text_bounds = {
        x = bounds.x + border_width,
        y = bounds.y + border_width,
        w = bounds.w - 2*border_width,
        h = bounds.h - 2*border_width,
    }

    -- Text padding
    if control == "combobox" then
        local button_width = imgui.get_style(control, "combo_button_width")
        local button_spacing = imgui.get_style(control, "combo_button_spacing")
        text_bounds.w = text_bounds.w - (button_width + button_spacing)
    elseif control == "valuebox" then
        -- nothing
    else
        local text_padding = imgui.get_style(control, "text_padding")
        if imgui.get_style(control, "text_alignment") == imgui.GuiTextAlignment.RIGHT then
            text_bounds.x = text_bounds.x - text_padding
        else
            text_bounds.x = text_bounds.x + text_padding            
        end
        text_bounds.w = text_bounds.w - 2*text_padding
    end

    return text_bounds
end


---@param state GuiState
---@return string
local function state_text(state)
    local map = {
        [imgui.GuiState.DISABLED] = "disabled",
        [imgui.GuiState.FOCUSED] = "focused",
        [imgui.GuiState.PRESSED] = "pressed",
        [imgui.GuiState.NORMAL] = "normal",
    }
    return map[state]
end


---------------------------------------------------------------------------------


--[[
Module initialization function. Better to call it once during the 
loading phase of the application.
]]
function imgui.init()
    imgui.load_default_style()
    -- Override keyboard callbacks so that imgui gets notified
    local callbacks = {"keypressed", "textinput"}
    for _, callback_name in ipairs(callbacks) do
        local framework_func = love[callback_name] or function(...) end
        local imgui_func = imgui[callback_name] or function(...) end
        love[callback_name] = function(...)
            framework_func(...)
            imgui_func(...)
        end
    end
end


function imgui.end_frame()
    g_state.key_pressed = ""
    g_state.textinput_pressed = ""
end


function imgui.keypressed(key, scancode, is_repeat)
    g_state.key_pressed = key
end


function imgui.textinput(text)
    g_state.textinput_pressed = text
end


--[[

]]
function imgui.new_frame()
    -- Clear last input
    g_state.key_pressed = ""
end


--[[

]]
function imgui.enable()
    if g_state.state == imgui.GuiState.DISABLED then
        g_state.state = imgui.GuiState.NORMAL
    end
end


--[[

]]
function imgui.disable()
    if g_state.state == imgui.GuiState.NORMAL then
        g_state.state = imgui.GuiState.DISABLED
    end
end


--[[

]]
function imgui.lock()
    g_state.locked = true
end


--[[

]]
function imgui.unlock()
    g_state.locked = false
end


--[[

]]
function imgui.is_locked()
    return g_state.locked
end


--[[

]]
---
---@param alpha number
function imgui.fade(alpha)
    g_state.alpha = math.max(0, math.min(1.0, alpha))
end


--[[

]]
---
---@param state GuiState
function imgui.set_state(state)
    g_state.state = state
end


--[[

]]
function imgui.get_state()
    return g_state.state
end


--[[

]]
---@param font userdata
function imgui.set_font(font)
    g_state.font = font
    imgui.set_style("default", "text_size", font:getHeight())
end


--[[

]]
---@return userdata
function imgui.get_font()
    return g_state.font
end


--[[

]]
---comment
---@param control ControlType
---@param property ControlProperty
---@param value number
function imgui.set_style(control, property, value)
    assert(g_state.style[control], string.format("imgui style control '%s' does not exist", control))
    assert(g_state.style[control][property], string.format("imgui style property '%s' for control '%s' does not exist", property, control))

    g_state.style[control][property] = value
    -- Propagation of default style
    if control == "default" then
        for c, c_style in pairs(g_state.style) do
            if c ~= control and c_style[property] ~= nil then
                c_style[property] = value
            end
        end
    end
end


--[[

]]
---@param control ControlType
---@param property ControlProperty
---@return number
function imgui.get_style(control, property)
    assert(g_state.style[control], string.format("imgui style control '%s' does not exist", control))
    assert(g_state.style[control][property], string.format("imgui style property '%s' for control '%s' does not exist", property, control))

    return g_state.style[control][property]
end


--[[

]]
function imgui.load_default_style()
    -- Default base properties
    imgui.set_style("default", "border_color_normal", 0x838383ff)
    imgui.set_style("default", "base_color_normal", 0xc9c9c9ff)
    imgui.set_style("default", "text_color_normal", 0x686868ff)
    imgui.set_style("default", "border_color_focused", 0x5bb2d9ff)
    imgui.set_style("default", "base_color_focused", 0xc9effeff)
    imgui.set_style("default", "text_color_focused", 0x6c9bbcff)
    imgui.set_style("default", "border_color_pressed", 0x0492c7ff)
    imgui.set_style("default", "base_color_pressed", 0x97e8ffff)
    imgui.set_style("default", "text_color_pressed", 0x368bafff)
    imgui.set_style("default", "border_color_disabled", 0xb5c1c2ff)
    imgui.set_style("default", "base_color_disabled", 0xe6e9e9ff)
    imgui.set_style("default", "text_color_disabled", 0xaeb7b8ff)
    imgui.set_style("default", "border_width", 1)
    imgui.set_style("default", "text_padding", 0)
    imgui.set_style("default", "text_alignment", imgui.GuiTextAlignment.LEFT)

    -- Control-specific properties
    imgui.set_style("label", "text_alignment", imgui.GuiTextAlignment.LEFT)
    imgui.set_style("button", "border_width", 2)
    imgui.set_style("slider", "text_padding", 4)
    imgui.set_style("checkbox", "text_padding", 4)
    imgui.set_style("checkbox", "text_alignment", imgui.GuiTextAlignment.RIGHT)
    imgui.set_style("textbox", "text_padding", 4)
    imgui.set_style("textbox", "text_alignment", imgui.GuiTextAlignment.LEFT)
    imgui.set_style("valuebox", "text_padding", 4)
    imgui.set_style("valuebox", "text_alignment", imgui.GuiTextAlignment.LEFT)
    imgui.set_style("spinner", "text_padding", 4)
    imgui.set_style("spinner", "text_alignment", imgui.GuiTextAlignment.RIGHT)
    imgui.set_style("statusbar", "text_padding", 8)
    imgui.set_style("statusbar", "text_alignment", imgui.GuiTextAlignment.LEFT)

    -- Extended properties
    imgui.set_style("default", "text_size", default_font:getHeight())
    imgui.set_style("default", "text_spacing", 1)
    imgui.set_style("default", "line_color", 0x90abb5ff)
    imgui.set_style("default", "background_color", 0xf5f5f5ff)
    imgui.set_style("toggle", "group_padding", 2)
    imgui.set_style("slider", "slider_width", 16)
    imgui.set_style("slider", "slider_padding", 1)
    imgui.set_style("progressbar", "progress_padding", 1)
    imgui.set_style("checkbox", "check_padding", 1)
    imgui.set_style("combobox", "combo_button_width", 40)
    imgui.set_style("combobox", "combo_button_spacing", 2)
    imgui.set_style("dropdownbox", "arrow_padding", 16)
    imgui.set_style("dropdownbox", "dropdown_items_spacing", 2)
    imgui.set_style("textbox", "text_lines_spacing", 4)
    imgui.set_style("textbox", "text_inner_padding", 4)
    imgui.set_style("spinner", "spin_button_width", 24)
    imgui.set_style("spinner", "spin_button_spacing", 2)
    imgui.set_style("scrollbar", "border_width", 0)
    imgui.set_style("scrollbar", "arrows_visible", 1)
    imgui.set_style("scrollbar", "arrows_size", 6)
    imgui.set_style("scrollbar", "scroll_slider_padding", 0)
    imgui.set_style("scrollbar", "scroll_slider_size", 16)
    imgui.set_style("scrollbar", "scroll_padding", 0)
    imgui.set_style("scrollbar", "scroll_speed", 12)
    imgui.set_style("listview", "list_items_height", 24)
    imgui.set_style("listview", "list_items_spacing", 2)
    imgui.set_style("listview", "scrollbar_width", 12)
    imgui.set_style("listview", "scrollbar_side", 1)
    imgui.set_style("colorpicker", "color_selector_size", 8)
    imgui.set_style("colorpicker", "huebar_width", 16)
    imgui.set_style("colorpicker", "huebar_padding", 8)
    imgui.set_style("colorpicker", "huebar_selector_height", 8)
    imgui.set_style("colorpicker", "huebar_selector_overflow", 2)

    g_state.font = default_font
end


function imgui.load_jungle_style()
    imgui.set_style("default", "border_color_normal", 0x60827dff)
    imgui.set_style("default", "base_color_normal", 0x2c3334ff)
    imgui.set_style("default", "text_color_normal", 0x82a29fff)
    imgui.set_style("default", "border_color_focused", 0x5f9aa8ff)
    imgui.set_style("default", "base_color_focused", 0x334e57ff)
    imgui.set_style("default", "text_color_focused", 0x6aa9b8ff)
    imgui.set_style("default", "border_color_pressed", 0xa9cb8dff)
    imgui.set_style("default", "base_color_pressed", 0x3b6357ff)
    imgui.set_style("default", "text_color_pressed", 0x97af81ff)
    imgui.set_style("default", "border_color_disabled", 0x5b6462ff)
    imgui.set_style("default", "base_color_disabled", 0x2c3334ff)
    imgui.set_style("default", "text_color_disabled", 0x666b69ff)
    imgui.set_style("default", "text_spacing", 0)
    imgui.set_style("default", "line_color", 0x638465ff)
    imgui.set_style("default", "background_color", 0x2b3a3aff)
end


--[[
Example:

    local window_closed = false
    if not window_closed then
        window_closed = imgui.window_box({x = 100, y = 100, w = 500, h= 400}, "Hello")
    end
]]
---@param bounds Rectangle
---@param title string
---@return boolean
function imgui.window_box(bounds, title)
    local status_bar_height = WINDOWBOX_STATUSBAR_HEIGHT
    
    local statusbar = {
        x = bounds.x, 
        y = bounds.y, 
        w = bounds.w, 
        h = status_bar_height,
    }

    if bounds.h < 2*status_bar_height then
        bounds.h = 2*status_bar_height
    end

    local window_panel = {
        x = bounds.x, 
        y = bounds.y + status_bar_height - 1,
        w = bounds.w,
        h = bounds.h - status_bar_height + 1,
    }
    local close_button_rect = {
        x = statusbar.x + statusbar.w - imgui.get_style("statusbar", "border_width") - 20,
        y = statusbar.y + status_bar_height/2 - 18/2,
        w = 18,
        h = 18,
    }

    -- Drawing
    imgui.status_bar(statusbar, title)
    imgui.panel(window_panel, "")
    local style_cache = {
        border_width = imgui.get_style("button", "border_width"),
        text_alignment = imgui.get_style("button", "text_alignment"),
    }
    imgui.set_style("button", "border_width", 1)
    imgui.set_style("button", "text_alignment", imgui.GuiTextAlignment.CENTER)

    --//TODO[javi]: With icons?
    local clicked = imgui.button(close_button_rect, "x")

    for k, v in pairs(style_cache) do
        imgui.set_style("button", k, v)
    end

    return clicked
end


--[[

]]
---@param bounds Rectangle
---@param text string
function imgui.status_bar(bounds, text)
    local state = g_state.state
    -- Rectangle
    local border_width = imgui.get_style("statusbar", "border_width")
    local border_color = get_color(imgui.get_style("statusbar", state ~= imgui.GuiState.DISABLED and "border_color_normal" or "border_color_disabled"))
    border_color = fade(border_color, g_state.alpha)
    local color = get_color(imgui.get_style("statusbar", state ~= imgui.GuiState.DISABLED and "base_color_normal" or "base_color_disabled"))
    color = fade(color, g_state.alpha)
    draw_rectangle(bounds, border_width, border_color, color)
    -- Text
    local textbounds = text_bounds("statusbar", bounds)
    local alignment = imgui.get_style("statusbar", "text_alignment")
    local tint = get_color(imgui.get_style("statusbar", state ~= imgui.GuiState.DISABLED and "text_color_normal" or "text_color_disabled"))
    tint = fade(tint, g_state.alpha)
    draw_text(text, textbounds, alignment, tint)
end


--[[

]]
---@param bounds Rectangle
---@param text string
function imgui.panel(bounds, text)
    local state = g_state.state
    local statusbar = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = WINDOWBOX_STATUSBAR_HEIGHT
    }
    if text ~= "" then
        if bounds.h < 2*WINDOWBOX_STATUSBAR_HEIGHT then
            bounds.h = 2*WINDOWBOX_STATUSBAR_HEIGHT
        end
        bounds.y = bounds.y + WINDOWBOX_STATUSBAR_HEIGHT - 1
        bounds.h = bounds.h - WINDOWBOX_STATUSBAR_HEIGHT + 1

        imgui.status_bar(statusbar, text)
    end

    local border_width = PANEL_BORDER_WIDTH
    local border_color = get_color(imgui.get_style("default", state ~= imgui.GuiState.DISABLED and "border_color_disabled" or "line_color"))
    border_color = fade(border_color, g_state.alpha)
    local color = get_color(imgui.get_style("default", state ~= imgui.GuiState.DISABLED and "background_color" or "base_color_disabled"))
    color = fade(color, g_state.alpha)
    draw_rectangle(bounds, border_width, border_color, color)
end


--[[
Example:

    imgui.line({x = 100, y = 600, w = 500, h = 10}, "Line separator")
]]
---@param bounds Rectangle
---@param text string
function imgui.line(bounds, text)
    local state = g_state.state
    local color = fade(get_color(imgui.get_style("default", state == imgui.GuiState.DISABLED and "border_color_disabled" or "line_color")), g_state.alpha)

    if text == "" then
        local rect = {
            x = bounds.x,
            y = bounds.y + bounds.h/2,
            w = bounds.w,
            h = 1,
        }
        draw_rectangle(rect, 0, BLANK, color)
    else
        local text_rect = {
            x = bounds.x + LINE_MARGIN_TEXT,
            y = bounds.y,
            w = g_state.font:getWidth(text),
            h = bounds.h,
        }
        local rect_1 = {
            x = bounds.x,
            y = bounds.y + bounds.h/2,
            w = LINE_MARGIN_TEXT - LINE_TEXT_PADDING,
            h = 1,
        }
        local rect_2 = {
            x = bounds.x + LINE_MARGIN_TEXT + text_rect.w + LINE_TEXT_PADDING,
            y = bounds.y + bounds.h/2,
            w = bounds.w - text_rect.w - LINE_MARGIN_TEXT - LINE_TEXT_PADDING,
            h = 1,
        }

        draw_rectangle(rect_1, 0, BLANK, color)
        draw_text(text, text_rect, imgui.GuiTextAlignment.LEFT, color)
        draw_rectangle(rect_2, 0, BLANK, color)
    end
end


--[[

]]
---@param bounds Rectangle
---@param text string
---@return boolean
function imgui.button(bounds, text)
    local state = g_state.state
    local pressed = false

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, bounds) then
            if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end

            if input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                pressed = true
            end
        end
    end

    -- Rectangle
    local statetext = state_text(state)
    do
        local border_width = imgui.get_style("button", "border_width")
        local border_color = get_color(imgui.get_style("button", "border_color_"..statetext))
        border_color = fade(border_color, g_state.alpha)
        local color = get_color(imgui.get_style("button", "base_color_"..statetext))
        color = fade(color, g_state.alpha)
        draw_rectangle(bounds, border_width, border_color, color)
    end
    -- Text
    do
        local textbounds = text_bounds("button", bounds)
        local alignment = imgui.get_style("button", "text_alignment")
        local tint = get_color(imgui.get_style("button", "text_color_"..statetext))
        tint = fade(tint, g_state.alpha)
        draw_text(text, textbounds, alignment, tint)
    end

    return pressed
end


--[[
Example:

    imgui.label({x=100, y=125, w=100, h=25}, string.format("DeltaTime: %03.03f ms", 1000*g_DeltaTime))
]]
---@param bounds Rectangle
---@param text string
function imgui.label(bounds, text)
    local state = g_state.state
    local statetext = state_text(state)

    local textbounds = text_bounds("label", bounds)
    local alignment = imgui.get_style("label", "text_alignment")
    local tint = get_color(imgui.get_style("label", "text_color_"..statetext))
    tint = fade(tint, g_state.alpha)
    draw_text(text, textbounds, alignment, tint)
end


--[[
Example:

    if imgui.label_button({x = 100, y = 150, w=100, h=25}, "Click Me!") then
        print("You clicked me :o")
    end
]]
---@param bounds Rectangle
---@param text string
---@return boolean
function imgui.label_button(bounds, text)
    local state = g_state.state
    local pressed = false

    local buttonbounds = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = bounds.h,
    }

    local text_size = {
        w = g_state.font:getWidth(text),
        h = g_state.font:getHeight(),
    }
    if buttonbounds.w < text_size.w then
        buttonbounds.w = text_size.w
    end

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, buttonbounds) then
            if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end

            if input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                pressed = true
            end
        end
    end


    -- Draw
    local statetext = state_text(state)
    local textbounds = text_bounds("label", buttonbounds)
    local alignment = imgui.get_style("label", "text_alignment")
    local tint = get_color(imgui.get_style("label", "text_color_"..statetext))
    tint = fade(tint, g_state.alpha)
    draw_text(text, textbounds, alignment, tint)

    return pressed
end


--[[
Creates a toggle button element, which keeps its state
between frames.

- `bounds` is a rectangle-like table which specifies the
bounding box of the button.

- `text` is a label string for the button.

- `active` is the state flag of the button, and represents
whether the button is toggled or not.

Returns whether the button is toggled or not.

Example:

    local toggle_active = false
    toggle_active = imgui.toggle({x = 100, y = 175, w=100, h=25}, toggle_active and "Untoggle Me" or "Toggle Me", toggle_active)
]]
---@param bounds Rectangle
---@param text string
---@param active boolean
---@return boolean
function imgui.toggle(bounds, text, active)
    local state = g_state.state

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, bounds) then
            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            elseif input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.NORMAL
                active = not active
            else
                state = imgui.GuiState.FOCUSED
            end
        end
        
    end

    -- Draw
    local statetext = state_text(state)
    if state == imgui.GuiState.NORMAL then
        -- Rectangle
        local border_width = imgui.get_style("toggle", "border_width")
        local border_color = fade(get_color(imgui.get_style("toggle", active and "border_color_pressed" or "border_color_"..statetext)), g_state.alpha)
        local rect_color = fade(get_color(imgui.get_style("toggle", active and "base_color_pressed" or "base_color_"..statetext)), g_state.alpha)
        draw_rectangle(bounds, border_width, border_color, rect_color)
        -- Text
        local textbounds = text_bounds("toggle", bounds)
        local alignment = imgui.get_style("toggle", "text_alignment")
        local tint = fade(get_color(imgui.get_style("toggle", active and "text_color_pressed" or "text_color_"..statetext)), g_state.alpha)
        draw_text(text, textbounds, alignment, tint)
    else
        -- Rectangle
        local border_width = imgui.get_style("toggle", "border_width")
        local border_color = fade(get_color(imgui.get_style("toggle", "border_color_"..statetext)), g_state.alpha)
        local rect_color = fade(get_color(imgui.get_style("toggle", "base_color_"..statetext)), g_state.alpha)
        draw_rectangle(bounds, border_width, border_color, rect_color)
        -- Text
        local textbounds = text_bounds("toggle", bounds)
        local alignment = imgui.get_style("toggle", "text_alignment")
        local tint = fade(get_color(imgui.get_style("toggle", "text_color_"..statetext)), g_state.alpha)
        draw_text(text, textbounds, alignment, tint)
    end

    return active
end


--[[
Creates multiple toggle buttons in a group, where only
one can be active at a time.

- `bounds` is a rectangle-like table which specifies the 
bounds of the first toggle button. The rest of the elements
are automatically calculated.

- `texts` is a table of tables of strings, which represents the
labels of each of the toggle buttons. The group will
have as many elements as the `texts` table. Each sub-table
represents a row of the group. Sub-tables can have different
button amounts.

- `active_idx` represents the toggle button which is
currently active. This value can be out of bounds of the
`texts` table, signalling that no element is active. However,
once an element is activated, there is always one active.

Returns the currently active index element of the group.

Example:

    local texts = {{"one", "two", "three"}, {"four", "five", "six",},}
    local active_idx = 1
    active_idx = imgui.toggle_group({x = 125, y = 200, w=100, h=25}, texts, active_idx)
]]
---@param bounds Rectangle
---@param texts string[][]
---@param active_idx integer
---@return integer
function imgui.toggle_group(bounds, texts, active_idx)
    local boundX0 = bounds.x
    local prev_row_idx = 1
    local toggle_bounds = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = bounds.h,
    }
    local group_padding = imgui.get_style("toggle", "group_padding")
    local idx = 1
    for i, texts_row in ipairs(texts) do
        -- We change rows, we reset the horizontal coordinate and skip to the next line
        if prev_row_idx ~= i then
            toggle_bounds.x = boundX0
            toggle_bounds.y = toggle_bounds.y + toggle_bounds.h + group_padding
            prev_row_idx = i
        end
        -- Iterate over all text columns
        for j, text in ipairs(texts_row) do
            if idx == active_idx then
                imgui.toggle(toggle_bounds, text, true)
            elseif imgui.toggle(toggle_bounds, text, false) then
                active_idx = idx
            end

            toggle_bounds.x = toggle_bounds.x + toggle_bounds.w + group_padding
            idx = idx + 1
        end
    end

    return active_idx
end


--[[
Creates a checkbox element.

- `bounds` is a rectangle-type table which is used
to define the actual checkbox.

- `text` is the text to display after the checkbox.

- `checked` is the previous state of the checkbox.

Returns whether the checkbox is checked or not.

Example:

    local checked = true
    checked = imgui.checkbox({x = 100, y = 325, w=25, h=25}, "Check me", checked)
]]
---@param bounds Rectangle
---@param text string
---@param checked boolean
---@return boolean
function imgui.checkbox(bounds, text, checked)
    local state = g_state.state
    local text_padding = imgui.get_style("checkbox", "text_padding")
    local text_size = imgui.get_style("default", "text_size")
    local text_alignment = imgui.get_style("checkbox", "text_alignment")
    local border_width = imgui.get_style("checkbox", "border_width")
    local check_padding = imgui.get_style("checkbox", "check_padding")
    local textbounds = {
        x = bounds.x + bounds.w + text_padding,
        y = bounds.y + bounds.h/2 - text_size/2,
        w = g_state.font:getWidth(text),
        h = text_size,
    }
    if text_alignment == imgui.GuiTextAlignment.LEFT then
        textbounds.x = bounds.x - textbounds.w - text_padding
    end
    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        local total_bounds = {
            x = text_alignment == imgui.GuiTextAlignment.LEFT and textbounds.x or bounds.x,
            y = bounds.y,
            w = bounds.w + textbounds.w + text_padding,
            h = bounds.h,
        }
        if collision_point_rect(mouse_pos, total_bounds) then
            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end

            if input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                checked = not checked
            end
        end
    end

    -- Draw
    local statetext = state_text(state)

    local border_color = fade(get_color(imgui.get_style("checkbox", "border_color_"..statetext)), g_state.alpha)
    draw_rectangle(bounds, border_width, border_color, BLANK)

    if checked then
        local check_rect = {
            x = bounds.x + border_width + check_padding,
            y = bounds.y + border_width + check_padding,
            w = bounds.w - 2*(border_width + check_padding),
            h = bounds.h - 2*(border_width + check_padding),
        }
        local color = fade(get_color(imgui.get_style("checkbox", "text_color_"..statetext)), g_state.alpha)
        draw_rectangle(check_rect, 0, BLANK, color)
    end

    local alignment = text_alignment == imgui.GuiTextAlignment.RIGHT and imgui.GuiTextAlignment.LEFT or imgui.GuiTextAlignment.RIGHT
    local tint = fade(get_color(imgui.get_style("label", "text_color_"..statetext)), g_state.alpha)
    draw_text(text, textbounds, alignment, tint)

    return checked
end


--[[
Creates a combobox element, which can switch between text 
elements by clicking on it.

- `bounds` is a rectangle-like table which specifies the 
bounds of the button.

- `texts` is a table of strings, which represents the
labels of each of the combobox entries. The combobox will
have as many elements as the `texts` table.

- `active_idx` represents the combobox label which is
currently active. This value can be out of bounds of the
`texts` table, but it will be clamped to the range of
elements in the  `texts` table.

Returns the currently active index element of the combobox.

Example:

    local cb_idx = 1
    cb_idx = imgui.combobox({x = 100, y = 350, w=150, h=25}, {"First", "Second", "Third"}, cb_idx)
]]
---@param bounds Rectangle
---@param texts string[]
---@param active_idx integer
---@return integer
function imgui.combobox(bounds, texts, active_idx)
    local state = g_state.state
    local combo_button_width = imgui.get_style("combobox", "combo_button_width")
    local combo_button_spacing = imgui.get_style("combobox", "combo_button_spacing")
    local border_width = imgui.get_style("combobox", "border_width")
    local text_alignment = imgui.get_style("combobox", "text_alignment")

    local combobox = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w - (combo_button_width + combo_button_spacing),
        h = bounds.h
    }
    local selector = {
        x = bounds.x + combobox.w + combo_button_spacing,
        y = bounds.y,
        w = combo_button_width,
        h = bounds.h,
    }

    -- Active clamping
    active_idx = math.max(1, math.min(active_idx, #texts))

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked and #texts > 1 then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, combobox)  or collision_point_rect(mouse_pos, selector) then
            if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                -- Cycle between labels
                active_idx = active_idx + 1
                if active_idx > #texts then
                    active_idx = 1
                end
            end

            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end
        end
    end

    -- Draw
    local statetext = state_text(state)
    -- Combobox
    local border_color = fade(get_color(imgui.get_style("combobox", "border_color_"..statetext)), g_state.alpha)
    local color = fade(get_color(imgui.get_style("combobox", "base_color_"..statetext)), g_state.alpha)
    draw_rectangle(combobox, border_width, border_color, color)
    local textbounds = text_bounds("combobox", combobox)
    local tint = fade(get_color(imgui.get_style("combobox", "text_color_"..statetext)), g_state.alpha)
    draw_text(texts[active_idx], textbounds, text_alignment, tint)
    -- Selector
    local style_cache = {
        border_width = imgui.get_style("button", "border_width"),
        text_alignment = imgui.get_style("button", "text_alignment"),
    }
    imgui.set_style("button", "border_width", 1)
    imgui.set_style("button", "text_alignment", imgui.GuiTextAlignment.CENTER)

    --//TODO[javi]: With icons?
    local clicked = imgui.button(selector, string.format("%d/%d", active_idx, #texts))

    for k, v in pairs(style_cache) do
        imgui.set_style("button", k, v)
    end

    return active_idx
end


--[[
Creates a dropdown box element, where multiple labels are stored
and the user can select one of them.

- `bounds`

- `texts`

- `active_idx`

- `editable` represents the dropdownbox has been selected previously
and the user can now modify its contents via the dropdown menu.

Returns whether the dropdown was clicked and the current active
index.

The pressed return value can be used to toggle the `editable` flag.

Example:

    local ddpressed = false
    local active_idx
    local editable = false
    ddpressed, active_idx = imgui.dropdown({x = 100, y = 400, w=150, h=25}, { "Javi", "Mimi", "Iris", "Gabriel" }, active_idx, editable)
    if ddpressed then
        editable = not editable
    end

]]
---@param bounds Rectangle
---@param texts string[]
---@param active_idx integer
---@param editable boolean
---@return boolean
---@return integer
function imgui.dropdown(bounds, texts, active_idx, editable)
    local state = g_state.state
    local pressed = false
    local focused_idx = -1
    local selected_idx = active_idx
    local dropdown_items_spacing = imgui.get_style("dropdownbox", "dropdown_items_spacing")
    local border_width = imgui.get_style("dropdownbox", "border_width")
    local text_alignment = imgui.get_style("dropdownbox", "text_alignment")
    local arrow_padding = imgui.get_style("dropdownbox", "arrow_padding")

    local open_rect = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = (#texts+1)*(bounds.h + dropdown_items_spacing)
    }
    local item_rect = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = bounds.h
    }

    -- Logic
    if state ~= imgui.GuiState.DISABLED and (editable or not g_state.locked) and #texts > 1 then
        local mouse_pos = input_mouse_position()

        if editable then
            state = imgui.GuiState.PRESSED
            if not collision_point_rect(mouse_pos, open_rect) then
                if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) or input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                    pressed = true
                end
            end

            if collision_point_rect(mouse_pos, bounds) and input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                pressed = true
            end

            for i= 1, #texts do
                item_rect.y = item_rect.y + (bounds.h + dropdown_items_spacing)
                if collision_point_rect(mouse_pos, item_rect) then
                    focused_idx = i
                    if input_is_mouse_released(LEFT_MOUSE_BUTTON) then
                        selected_idx = i
                        pressed = true
                    end
                    break
                end
            end

            item_rect = {
                x = bounds.x,
                y = bounds.y,
                w = bounds.w,
                h = bounds.h
            }
        else
            if collision_point_rect(mouse_pos, bounds) then
                if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                    pressed = true
                    state = imgui.GuiState.PRESSED
                else
                    state = imgui.GuiState.FOCUSED
                end
            end
        end
    end

    -- Draw
    if editable then
        imgui.panel(open_rect, "")
    end
    local statetext = state_text(state)
    local border_color = fade(get_color(imgui.get_style("dropdownbox", "border_color_"..statetext)), g_state.alpha)
    local color = fade(get_color(imgui.get_style("dropdownbox", "base_color_"..statetext)), g_state.alpha)
    draw_rectangle(bounds, border_width, border_color, color)
    local textbounds = text_bounds("default", bounds)
    local tint = fade(get_color(imgui.get_style("dropdownbox", "text_color_"..statetext)), g_state.alpha)
    draw_text(texts[selected_idx], textbounds, text_alignment, tint)
    if editable then
        for i = 1, #texts do
            item_rect.y = item_rect.y + bounds.h + dropdown_items_spacing
            local textbounds = text_bounds("default", item_rect)
            if i == selected_idx then
                local border_color = fade(get_color(imgui.get_style("dropdownbox", "border_color_pressed")), g_state.alpha)
                local color = fade(get_color(imgui.get_style("dropdownbox", "base_color_pressed")), g_state.alpha)
                draw_rectangle(item_rect, border_width, border_color, color)
                local tint = fade(get_color(imgui.get_style("dropdownbox", "text_color_pressed")), g_state.alpha)
                draw_text(texts[i], textbounds, text_alignment, tint)
            elseif i == focused_idx then
                local border_color = fade(get_color(imgui.get_style("dropdownbox", "border_color_focused")), g_state.alpha)
                local color = fade(get_color(imgui.get_style("dropdownbox", "base_color_focused")), g_state.alpha)
                draw_rectangle(item_rect, border_width, border_color, color)
                local tint = fade(get_color(imgui.get_style("dropdownbox", "text_color_pressed")), g_state.alpha)
                draw_text(texts[i], textbounds, text_alignment, tint)
            else
                local tint = fade(get_color(imgui.get_style("dropdownbox", "text_color_normal")), g_state.alpha)
                draw_text(texts[i], textbounds, text_alignment, tint)
            end

        end

    end
    -- //TODO[javi]: icon usage here
    local arrow_rect = {
        x = bounds.x + bounds.w - arrow_padding,
        y = bounds.y + bounds.h/2 - 2,
        w = 10,
        h = 10,
    }
    draw_text("v", arrow_rect, imgui.GuiTextAlignment.CENTER, tint)

    return pressed, selected_idx
end


--[[

]]
---@param bounds Rectangle
---@param text string
---@param value number
---@param min number
---@param max number
---@param editable boolean
---@return boolean
---@return number
function imgui.spinner(bounds, text, value, min, max, editable)
    local state = g_state.state
    local spin_button_width = imgui.get_style("spinner", "spin_button_width")
    local spin_button_spacing = imgui.get_style("spinner", "spin_button_spacing")
    local text_padding = imgui.get_style("spinner", "text_padding")
    local text_size = imgui.get_style("default", "text_size")
    local text_alignment = imgui.get_style("spinner", "text_alignment")

    local spinner_rect = {
        x = bounds.x + spin_button_width + spin_button_spacing,
        y = bounds.y,
        w = bounds.w - 2*(spin_button_width + spin_button_spacing),
        h = bounds.h,
    }
    local left_rect = {
        x = bounds.x,
        y = bounds.y,
        w = spin_button_width,
        h = bounds.h,
    }
    local right_rect = {
        x = bounds.x + bounds.w - spin_button_width,
        y = bounds.y,
        w = spin_button_width,
        h = bounds.h,
    }
    local textbounds = {
        x = bounds.x + bounds.w + text_padding,
        y = bounds.y + bounds.h/2 - text_size/2,
        w = g_state.font:getWidth(text),
        h = text_size,
    }
    if text_alignment == imgui.GuiTextAlignment.LEFT then
        textbounds.x = bounds.x - textbounds.w - text_padding
    end

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, bounds) then
            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end
        end
    end

    if imgui.button(left_rect, "<") then
        value = value - 1
    end
    if imgui.button(right_rect, ">") then
       value = value + 1
    end

    if not editable then
        value = math.max(min, math.min(value, max))
    end

    -- Draw
    local pressed = false
    pressed, value = imgui.valuebox(spinner_rect, "", value, min, max, editable)

    local statetext = state_text(state)
    local alignment = text_alignment == imgui.GuiTextAlignment.RIGHT and imgui.GuiTextAlignment.LEFT or imgui.GuiTextAlignment.RIGHT
    local tint = fade(get_color(imgui.get_style("label", "text_color_"..statetext)), g_state.alpha)
    draw_text(text, textbounds, alignment, tint)

    return pressed, value
end


--[[
//TODO[javi]: Issue here with textbounds?
]]
---@param bounds Rectangle
---@param text string
---@param value number
---@param min number
---@param max number
---@param editable boolean
---@return boolean
---@return number
function imgui.valuebox(bounds, text, value, min, max, editable)
    local state = g_state.state
    local pressed = false
    local text_size = imgui.get_style("default", "text_size")
    local text_padding = imgui.get_style("valuebox", "text_padding")
    local text_alignment = imgui.get_style("valuebox", "text_alignment")
    local border_width = imgui.get_style("valuebox", "border_width")

    local textbounds = {
        x = bounds.x + bounds.w + text_padding,
        y = bounds.y + bounds.h/2 - text_size/2,
        w = g_state.font:getWidth(text),
        h = text_size,
    }
    if text_alignment == imgui.GuiTextAlignment.LEFT then
        textbounds.x = bounds.x - textbounds.w - text_padding
    end

    local text_value = tostring(value)

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        local value_changed = false

        if editable then
            state = imgui.GuiState.PRESSED
            local keycount = string.len(text_value)

            -- Add numbers
            if g_state.font:getWidth(text_value) < bounds.w then
                local key = g_state.key_pressed
                if key >= "0" and key <= "9" then
                    text_value = text_value .. key
                    keycount = keycount + 1
                    value_changed = true
                end
            end

            -- Delete numbers
            if keycount > 0 and input_is_key_pressed("backspace") then
                text_value = string.sub(text_value, 1, -2) -- Remove last char
                value_changed = true
            end

            -- Update
            if value_changed then
                value = tonumber(text_value) or 0
            end

            -- End edition
            if input_is_key_pressed("return") or (not collision_point_rect(mouse_pos, bounds) and input_is_mouse_pressed(LEFT_MOUSE_BUTTON)) then
                pressed = true
            end
        else
            value = math.max(min, math.min(value, max))
            if collision_point_rect(mouse_pos, bounds) then
                state = imgui.GuiState.FOCUSED
                if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                    pressed = true
                end
            end
        end
    end

    -- Draw
    local base_color = BLANK
    if state == imgui.GuiState.PRESSED then
        base_color = get_color(imgui.get_style("valuebox", "base_color_pressed"))
    elseif state == imgui.GuiState.DISABLED then
        base_color = get_color(imgui.get_style("valuebox", "base_color_disabled"))
    end

    local statetext = state_text(state)
    local border_color = fade(get_color(imgui.get_style("valuebox", "border_color_"..statetext)), g_state.alpha)
    draw_rectangle(bounds, border_width, border_color, base_color)
    local textbounds = text_bounds("valuebox", bounds)
    local tint = fade(get_color(imgui.get_style("valuebox", "text_color_"..statetext)), g_state.alpha)
    draw_text(text_value, textbounds, imgui.GuiTextAlignment.CENTER, tint)

    -- cursor
    if editable then
        local cursor_rect = {
            x = bounds.x + g_state.font:getWidth(text_value)/2 + bounds.w/2 + 2,
            y = bounds.y + 2*border_width,
            w = 4,
            h = bounds.h - 4*border_width,
        }
        local color = fade(get_color(imgui.get_style("valuebox", "border_color_pressed")), g_state.alpha)
        draw_rectangle(cursor_rect, 0, BLANK, color)
    end

    local alignment = text_alignment == imgui.GuiTextAlignment.RIGHT and imgui.GuiTextAlignment.LEFT or imgui.GuiTextAlignment.RIGHT
    local label_tint = fade(get_color(imgui.get_style("label", "text_color_"..statetext)), g_state.alpha)
    draw_text(text, textbounds, alignment, label_tint)

    return pressed, value
end


--[[

]]
---@param bounds Rectangle
---@param text string
---@param editable boolean
---@return boolean
---@return string
function imgui.textbox(bounds, text, editable)
    local state = g_state.state
    local pressed = false
    local text_width = g_state.font:getWidth(text)
    local textbounds = text_bounds("textbox", bounds)
    local text_alignment = (editable and text_width >= textbounds.w) and imgui.GuiTextAlignment.RIGHT or imgui.get_style("textbox", "text_alignment")
    local border_width = imgui.get_style("textbox", "border_width")
    local text_padding = imgui.get_style("textbox", "text_padding")
    local inner_padding = imgui.get_style("textbox", "text_inner_padding")
    local text_size = imgui.get_style("default", "text_size")

    local cursor_rect = {
        x = bounds.x + text_padding + text_width + 2,
        y = bounds.y + bounds.h/2 - text_size,
        w = 4,
        h = 2*text_size,
    }
    if cursor_rect.h >= bounds.h then
        cursor_rect.h = bounds.h - 2*border_width
    end
    if cursor_rect.y < (bounds.y + border_width) then
        cursor_rect.y = bounds.y + border_width
    end

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()

        if editable then
            state = imgui.GuiState.PRESSED
            local keycount = string.len(text)

            if g_state.textinput_pressed ~= "" then
                text = text .. g_state.textinput_pressed
            end

            -- Delete text
            if keycount > 0 and input_is_key_pressed("backspace") then
                -- From https://love2d.org/wiki/love.textinput
                -- get their byte offset to the last UTF-8 character in the string.
                local byteoffset = utf8.offset(text, -1)
                if byteoffset then
                    -- remove the last UTF-8 character.
                    -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                    text = string.sub(text, 1, byteoffset - 1)
                end
            end

            -- Commit
            if input_is_key_pressed("return") or (not collision_point_rect(mouse_pos, bounds) and input_is_mouse_pressed(LEFT_MOUSE_BUTTON)) then
                pressed = true
            end

            -- Cursor alignment
            if text_alignment == imgui.GuiTextAlignment.CENTER then
                cursor_rect.x = bounds.x + text_width/2 + bounds.w*2 + 1
            elseif text_alignment == imgui.GuiTextAlignment.RIGHT then
                cursor_rect.x = bounds.x + bounds.w - inner_padding - border_width
            end
        else
            if collision_point_rect(mouse_pos, bounds) then
                state = imgui.GuiState.FOCUSED
                if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                    pressed = true
                end
            end
        end
    end

    -- Draw
    local statetext = state_text(state)
    local border_color = fade(get_color(imgui.get_style("textbox", "border_color_"..statetext)), g_state.alpha)
    if state == imgui.GuiState.PRESSED then
        local color = fade(get_color(imgui.get_style("textbox", "base_color_pressed")), g_state.alpha)
        draw_rectangle(bounds, border_width, border_color, color)
    elseif state == imgui.GuiState.DISABLED then
        local color = fade(get_color(imgui.get_style("textbox", "base_color_disabled")), g_state.alpha)
        draw_rectangle(bounds, border_width, border_color, color)
    else
        draw_rectangle(bounds, 1, border_color, BLANK)
    end

    -- Clip text to textbox, in case we write too much
    BeginScissorMode(textbounds)
    local tint = fade(get_color(imgui.get_style("textbox", "text_color_"..statetext)), g_state.alpha)
    draw_text(text, textbounds, text_alignment, tint)
    EndScissorMode()

    -- Cursor
    if editable then
        local color = fade(get_color(imgui.get_style("textbox", "border_color_pressed")), g_state.alpha)
        draw_rectangle(cursor_rect, 0, BLANK, color)
    end

    return pressed, text
end


--[[
Example:

    imgui.dummy_rect({x=500, y=175, w=300, h=300}, "DUMMY RECT")
]]
---@param bounds Rectangle
---@param text string
function imgui.dummy_rect(bounds, text)
    local state = g_state.state

    -- Logic
    if state  ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()
        if collision_point_rect(mouse_pos, bounds) then
            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end
        end
    end

    -- Draw
    local color = fade(get_color(imgui.get_style("default", state ~= imgui.GuiState.DISABLED and "base_color_normal" or "base_color_disabled")), g_state.alpha)
    draw_rectangle(bounds, 0, BLANK, color)
    local textbounds = text_bounds("default", bounds)
    local tint = fade(get_color(imgui.get_style("button", state ~= imgui.GuiState.DISABLED and "text_color_normal" or "text_color_disabled")), g_state.alpha)
    draw_text(text, textbounds, imgui.GuiTextAlignment.CENTER, tint)
end


--[[
- `bounds`
- `text`: string, panel title
- `content`
- `scroll`: Vector2-like table (x, y), used to know where the scroll bars are and which content
is visible

Returns:
- `view`: rectangle of the content that can be viewed
- `scroll_pos`: a `Vector2` of the updated input `scroll`

Example:

    -- Scroll panel state
    local view
    local scroll = Vector2(0, 0)
    -- Render scroll panel
    view, scroll = imgui.scroll_panel({x=500, y=500, w=300, h=300}, "Hello Scroll", {x=0, y=0, w=275, h=2525}, scroll)
    -- Render contents of scroll panel
    do
        -- Render only to view rectangle
        BeginScissorMode(is.sp.view)
        -- Bounds of elements need to be calculated w.r.t. the view and the scroll.
        local bounds = {
            x = is.sp.view.x + 10, 
            y = is.sp.view.y + is.sp.scroll.y + 10, 
            w = 200, 
            h = 25,
        }
        -- Render stuff to the panel
        for i = 1, 100 do
            imgui.label(bounds, string.format("Label %03d", i))
            bounds.y = bounds.y + bounds.h
        end
        -- Undo scissor
        EndScissorMode()
    end
]]
---@param bounds Rectangle
---@param text string
---@param content Rectangle
---@param scroll Vec2
---@return Rectangle
---@return Vec2
function imgui.scroll_panel(bounds, text, content, scroll)
    local state = g_state.state
    local scroll_pos = scroll and Vector2(scroll.x, scroll.y) or Vector2(0, 0)
    -- Text as headerbar, if any
    local scroll_bounds = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = bounds.h
    }
    local statusbar = {
        x = bounds.x,
        y = bounds.y,
        w = bounds.w,
        h = WINDOWBOX_STATUSBAR_HEIGHT,
    }
    scroll_bounds.h = math.max(scroll_bounds.h, 2*WINDOWBOX_STATUSBAR_HEIGHT)
    if text ~= "" then
        scroll_bounds.y = scroll_bounds.y + WINDOWBOX_STATUSBAR_HEIGHT - 1
        scroll_bounds.h = scroll_bounds.h - WINDOWBOX_STATUSBAR_HEIGHT + 1
    end

    local border_width = imgui.get_style("default", "border_width")
    local scrollbar_width = imgui.get_style("listview", "scrollbar_width")
    local scrollbar_side = imgui.get_style("listview", "scrollbar_side")
    local scrollbar_left = scrollbar_side == imgui.ScrollBarSide.LEFT
    local scroll_speed = imgui.get_style("scrollbar", "scroll_speed")

    local has_h_bar = (content.w > scroll_bounds.w - 2*border_width) and true or false
    local has_v_bar = (content.h > scroll_bounds.h - 2*border_width) and true or false

    -- Recheck in case the other scrollbar is visible
    if not has_h_bar then
        has_h_bar = (has_v_bar and (content.w > scroll_bounds.w - 2*border_width - scrollbar_width)) and true or false
    end
    if not has_v_bar then
        has_v_bar = (has_h_bar and (content.h > scroll_bounds.h - 2*border_width - scrollbar_width)) and true or false
    end

    local hbar_width = has_h_bar and scrollbar_width or 0
    local vbar_width = has_v_bar and scrollbar_width or 0
    local hbar_rect = {
        x = (scrollbar_left and (scroll_bounds.x + vbar_width) or (scroll_bounds.x)) + border_width,
        y = scroll_bounds.y + scroll_bounds.h - hbar_width - border_width,
        w = scroll_bounds.w - vbar_width - 2*border_width,
        h = hbar_width,
    }
    local vbar_rect = {
        x = scrollbar_left and (scroll_bounds.x + border_width) or (scroll_bounds.x + scroll_bounds.w - vbar_width - border_width),
        y = scroll_bounds.y + border_width,
        w = vbar_width,
        h = scroll_bounds.h - hbar_width - 2*border_width,
    }

    -- View area without scrollbars
    local view_rect
    if scrollbar_left then
        view_rect = {
            x = scroll_bounds.x + vbar_width + border_width,
            y = scroll_bounds.y + border_width,
            w = scroll_bounds.w - 2*border_width - vbar_width,
            h = scroll_bounds.h - 2*border_width - hbar_width,
        }
    else
        view_rect = {
            x = scroll_bounds.x + border_width,
            y = scroll_bounds.y + border_width,
            w = scroll_bounds.w - 2*border_width - vbar_width,
            h = scroll_bounds.h - 2*border_width - hbar_width,
        }
    end

    -- Clip view area
    view_rect.w = math.min(view_rect.w, content.w)
    view_rect.h = math.min(view_rect.h, content.h)

    local h_min = (scrollbar_left and -vbar_width or 0) - border_width
    local h_max = -border_width
    if has_h_bar then
        h_max = content.w - scroll_bounds.w + vbar_width + border_width - (scrollbar_left and vbar_width or 0)
    end
    local v_min = has_v_bar and 0 or -1
    local v_max = -border_width
    if has_v_bar then
        v_max = content.h - scroll_bounds.h + hbar_width + border_width
    end

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()

        if collision_point_rect(mouse_pos, scroll_bounds) then
            if input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                state = imgui.GuiState.PRESSED
            else
                state = imgui.GuiState.FOCUSED
            end

            -- Scrollbar keyboard input
            if has_h_bar then
                if input_is_key_held("right") then
                    scroll_pos.x = scroll_pos.x - scroll_speed
                end
                if input_is_key_held("left") then
                    scroll_pos.x = scroll_pos.x + scroll_speed
                end
            end
            if has_v_bar then
                if input_is_key_held("down") then
                    scroll_pos.y = scroll_pos.y - scroll_speed
                end
                if input_is_key_held("up") then
                    scroll_pos.y = scroll_pos.y + scroll_speed
                end
            end

            local wheel_move = input_mouse_wheel().y

            if has_h_bar and (input_is_key_held("lctrl") or input_is_key_held("rshift")) then
                scroll_pos.x = scroll_pos.x + 20*wheel_move
            else
                scroll_pos.y = scroll_pos.y + 20*wheel_move
            end
        end
    end

    scroll_pos.x = math.clamp(scroll_pos.x, -h_max, -h_min)
    scroll_pos.y = math.clamp(scroll_pos.y, -v_max, -v_min)

    -- Draw
    if text ~= "" then
        imgui.status_bar(statusbar, text)
    end

    draw_rectangle(scroll_bounds, 0, BLANK, get_color(imgui.get_style("default", "background_color")))

    local slider_cache = imgui.get_style("scrollbar", "scroll_slider_size")

    if has_h_bar then
        local slider_size = ((scroll_bounds.w - 2*border_width - vbar_width) / content.w)*(scroll_bounds.w - 2*border_width - vbar_width)
        imgui.set_style("scrollbar", "scroll_slider_size", slider_size)
        --//TODO[javi]: Fix horizontal scroll bar
        scroll_pos.x = 0 --imgui.scrollbar(hbar_rect, -scroll_pos.x, h_min, h_max)
    else
        scroll_pos.x = 0
    end

    if has_v_bar then
        local slider_size = ((scroll_bounds.h - 2*border_width - hbar_width) / content.h)*(scroll_bounds.h - 2*border_width - hbar_width)
        imgui.set_style("scrollbar", "scroll_slider_size", slider_size)
        scroll_pos.y = -imgui.scrollbar(vbar_rect, -scroll_pos.y, v_min, v_max)
    else
        scroll_pos.y = 0
    end

    -- Detail corner of both bars
    local statetext = state_text(state)
    if has_h_bar and has_v_bar then
        local corner_rect = {
            x = scrollbar_left and (scroll_bounds.x + border_width + 2) or (hbar_rect.x + hbar_rect.w + 2),
            y = vbar_rect.y + vbar_rect.h + 2,
            w = hbar_width - 4,
            h = vbar_width - 4,
        }
        draw_rectangle(corner_rect, 0, BLANK, fade(get_color(imgui.get_style("listview", "text_color_"..statetext)), g_state.alpha))
    end

    draw_rectangle(scroll_bounds, border_width, fade(get_color(imgui.get_style("listview", "border_color_"..statetext)), g_state.alpha), BLANK)

    imgui.set_style("scrollbar", "scroll_slider_size", slider_cache)

    return view_rect, scroll_pos
end


--[[

]]
---@param bounds Rectangle
---@param value number
---@param min number
---@param max number
---@return number
function imgui.scrollbar(bounds, value, min, max)
    local state = g_state.state
    local is_vertical = (bounds.w > bounds.h) and false or true
    local arrows_visible = imgui.get_style("scrollbar", "arrows_visible")
    local border_width = imgui.get_style("scrollbar", "border_width")
    local spinner_size = arrows_visible and (is_vertical and (bounds.w - 2*border_width) or (bounds.h - 2*border_width)) or 0

    local arrow_up_left = {
        x = bounds.x + border_width,
        y = bounds.y + border_width,
        w = spinner_size,
        h = spinner_size,
    }
    local arrow_down_right = {
        x = 0, y = 0, w = 0, h = 0,
    }
    local scrollbar_rect = table.copy(arrow_down_right)
    local slider_rect = table.copy(arrow_down_right)

    value = math.clamp(value, min, max)
    local range = max - min
    local slider_size = imgui.get_style("scrollbar", "scroll_slider_size")
    local scroll_speed = imgui.get_style("scrollbar", "scroll_speed")
    local scroll_padding = imgui.get_style("scrollbar", "scroll_padding")
    local scroll_slider_padding = imgui.get_style("scrollbar", "scroll_slider_padding")

    if is_vertical then
        arrow_down_right = {
            x = bounds.x + border_width,
            y = bounds.y + bounds.h - spinner_size - border_width,
            w = spinner_size,
            h = spinner_size,
        }
        scrollbar_rect = {
            x = bounds.x + border_width + scroll_padding,
            y = arrow_up_left.y + arrow_up_left.h,
            w = bounds.w - 2*(border_width + scroll_padding),
            h = bounds.h - arrow_up_left.h - arrow_down_right.h - 2*border_width,
        }
        slider_size = (slider_size >= scrollbar_rect.h) and (scrollbar_rect.h - 2) or slider_size
        slider_rect = {
            x = bounds.x + border_width + scroll_slider_padding,
            y = scrollbar_rect.y + ((value - min)/range)*(scrollbar_rect.h - slider_size),
            w = bounds.w - 2*(border_width + scroll_slider_padding),
            h = slider_size,
        }
    else
        arrow_down_right = {
            x = bounds.x + bounds.w - spinner_size - border_width,
            y = bounds.y + border_width,
            w = spinner_size,
            h = spinner_size,
        }
        scrollbar_rect = {
            x = arrow_up_left.x + arrow_up_left.w,
            y = bounds.y + border_width + scroll_padding,
            w = bounds.w - arrow_up_left.w - arrow_down_right.w - 2*border_width,
            h = bounds.h - 2*(border_width + scroll_padding),
        }
        slider_size = (slider_size >= scrollbar_rect.w) and (scrollbar_rect.w - 2) or slider_size
        slider_rect = {
            x = scrollbar_rect.x + ((value - min)/range)*(scrollbar_rect.w - slider_size),
            y = bounds.y + border_width + scroll_slider_padding,
            w = slider_size,
            h = bounds.h - 2*(border_width + scroll_slider_padding),
        }
    end

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()

        if collision_point_rect(mouse_pos, bounds) then
            state = imgui.GuiState.FOCUSED
            local wheel = input_mouse_wheel().y
            value = value + wheel

            if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                if collision_point_rect(mouse_pos, arrow_up_left) then
                    value = value - range/scroll_speed
                elseif collision_point_rect(mouse_pos, arrow_down_right) then
                    value = value + range/scroll_speed
                end
                state = imgui.GuiState.PRESSED
            elseif input_is_mouse_held(LEFT_MOUSE_BUTTON) then
                if not is_vertical then
                    local scrollarea_rect = {
                        x = arrow_up_left.x + arrow_up_left.w,
                        y = arrow_up_left.y,
                        w = scrollbar_rect.w,
                        h = bounds.h - 2*border_width,
                    }
                    if collision_point_rect(mouse_pos, scrollarea_rect) then
                        value = (((mouse_pos.x - scrollarea_rect.x - slider_rect.w/2)*range)/(scrollarea_rect.w - slider_rect.w) + min) 
                    end
                else
                    local scrollarea_rect = {
                        x = arrow_up_left.x,
                        y = arrow_up_left.y + arrow_up_left.h,
                        w = bounds.w - 2*border_width,
                        h = scrollbar_rect.h,
                    }
                    if collision_point_rect(mouse_pos, scrollarea_rect) then
                        value = (((mouse_pos.y - scrollarea_rect.y - slider_rect.h/2)*range)/(scrollarea_rect.h - slider_rect.h) + min) 
                    end
                end
            end
        end

        -- re-clamp
        value = math.max(min, math.min(value, max))
    end

    -- Draw
    local statetext = state_text(state)
    draw_rectangle(bounds, border_width, get_faded_color("listview", "border_color_"..statetext), get_faded_color("default", "border_color_disabled"))
    draw_rectangle(scrollbar_rect, 0, BLANK, get_faded_color("button", "base_color_normal"))
    draw_rectangle(slider_rect, 0, BLANK, get_faded_color("slider", "border_color_"..statetext))

    if arrows_visible == 1 then
        local decrease_rect = {
            x = arrow_up_left.x,
            y = arrow_up_left.y,
            w = is_vertical and bounds.w or bounds.h,
            h = is_vertical and bounds.w or bounds.h,
        }
        local increase_rect = {
            x = arrow_down_right.x,
            y = arrow_down_right.y,
            w = is_vertical and bounds.w or bounds.h,
            h = is_vertical and bounds.w or bounds.h,
        }

        --//TODO[javi]: With icons?
        draw_text(is_vertical and "^" or "<", decrease_rect, imgui.GuiTextAlignment.CENTER, get_faded_color("dropdownbox", "text_color_"..statetext))
        draw_text(is_vertical and "v" or ">", increase_rect, imgui.GuiTextAlignment.CENTER, get_faded_color("dropdownbox", "text_color_"..statetext))
    end

    return value
end


--[[

]]
---@param bounds Rectangle
---@param text string
---@param editable boolean
---@return boolean pressed
---@return string text
function imgui.textbox_multiline(bounds, text, editable)
    local state = g_state.state
    local pressed = false
    local border_width = imgui.get_style("textbox", "border_width")
    local text_inner_padding = imgui.get_style("textbox", "text_inner_padding")
    local text_size = imgui.get_style("default", "text_size")

    ---@type Rectangle
    local textarea_bounds = {
        x = bounds.x + border_width + text_inner_padding,
        y = bounds.y + border_width + text_inner_padding,
        w = bounds.w - 2*(border_width + text_inner_padding),
        h = bounds.h - 2*(border_width + text_inner_padding),
    }

    local scale_factor = 1

    -- Logic
    if state ~= imgui.GuiState.DISABLED and not g_state.locked then
        local mouse_pos = input_mouse_position()

        if editable then
            state = imgui.GuiState.PRESSED
            local keycount = string.len(text)

            if g_state.textinput_pressed ~= "" then
                text = text .. g_state.textinput_pressed
            end

            -- Delete text
            if keycount > 0 and input_is_key_pressed("backspace") then
                -- From https://love2d.org/wiki/love.textinput
                -- get their byte offset to the last UTF-8 character in the string.
                local byteoffset = utf8.offset(text, -1)
                if byteoffset then
                    -- remove the last UTF-8 character.
                    -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                    text = string.sub(text, 1, byteoffset - 1)
                end
            end

            -- Commit
            if input_is_key_pressed("return") or (not collision_point_rect(mouse_pos, bounds) and input_is_mouse_pressed(LEFT_MOUSE_BUTTON)) then
                pressed = true
            end
        else
            if collision_point_rect(mouse_pos, bounds) then
                state = imgui.GuiState.FOCUSED
                if input_is_mouse_pressed(LEFT_MOUSE_BUTTON) then
                    pressed = true
                end
            end
        end
    end

    -- Draw
    local statetext = state_text(state)
    if state == imgui.GuiState.PRESSED then
        local border_color = get_faded_color("textbox", "border_color_"..statetext)
        local color = get_faded_color("textbox", "base_color_pressed")
        draw_rectangle(bounds, border_width, border_color, color)
    elseif state == imgui.GuiState.DISABLED then
        local border_color = get_faded_color("textbox", "border_color_"..statetext)
        local color = get_faded_color("textbox", "base_color_disabled")
        draw_rectangle(bounds, border_width, border_color, color)
    else
        local border_color = get_faded_color("textbox", "border_color_"..statetext)
        draw_rectangle(bounds, 1, border_color, BLANK)
    end

    ---@type Vec2
    local cursor_pos = Vector2(textarea_bounds.x, textarea_bounds.y)

    local wrapped_width, wrapped_text = g_state.font:getWrap(text, bounds.w)
    local text_color =get_faded_color("textbox", "text_color_"..statetext)
    local cursor_dx = 0
    for _, text_line in ipairs(wrapped_text) do
        love.graphics.print({text_color, text_line}, cursor_pos.x, cursor_pos.y)
        cursor_dx = g_state.font:getWidth(text_line)
        cursor_pos.y = cursor_pos.y + text_size
    end

    if editable then
        local cursor_rect = {
            x = cursor_pos.x + cursor_dx,
            y = cursor_pos.y - text_size,
            w = 4,
            h = text_size + 2,
        }
        draw_rectangle(cursor_rect, 0, BLANK, get_faded_color("textbox", "border_color_pressed"))
    end

    return pressed, text
end