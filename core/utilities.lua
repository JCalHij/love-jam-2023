--[[
Simple `printf` function implementation. Takes a string and parameters.
]]
---@param fmt string
---@param ... any
function printf(fmt, ...)
    print(string.format(fmt, ...))
end


--[[
Function that indicates "_nothing to do_" or "_no operation_". Use it instead of `nil` for callbacks
or function pointers.
]]
function no_op()
end


--[[
Example: 

    local rect1 = { x = 4, y = 4, w = 8, h = 8, }
    local rect2 = { x = 6, y = 6, w = 8, h = 8, }
    local rect3 = { x = 15, y = 16, w = 3, h = 1, }
    collision_rect_rect(rect1, rect2) -- true
    collision_rect_rect(rect1, rect3) -- false
]]
---@param rect1 Rectangle
---@param rect2 Rectangle
---@return boolean
function collision_rect_rect(rect1, rect2)
    if 
    rect1.x < rect2.x + rect2.w and
    rect1.x + rect1.w > rect2.x and
    rect1.y < rect2.y + rect2.h and
    rect1.h + rect1.y > rect2.y then
        return true
    end
    return false
end


--[[

]]
---@param point Vec2
---@param rect Rectangle
---@return boolean
function collision_point_rect(point, rect)
    local x_check = (point.x >= rect.x) and (point.x < (rect.x + rect.w))
    local y_check = (point.y >= rect.y) and (point.y < (rect.y + rect.h))
    return x_check and y_check
end


--[[

]]
---@param x number
---@param y number
---@param r? number
---@param sx? number
---@param sy? number
function gfx_push_style(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or 1)
end


--[[

]]
function gfx_pop_style()
    love.graphics.pop()
end


--[[
Transforms position `pos` from screen coordinates to canvas coordinates.

On screen, the canvas is located at position (CanvasX, CanvasY), rendered
at scale (ScaleX, ScaleY).
]]
function screen_to_canvas(pos)
    assert(Vector2.isvector(pos))
    return Vector2((pos.x - CanvasX)/ScaleX, (pos.y - CanvasY) / ScaleY)
end


--[[
Transforms position `pos` from canvas coordinates to screen coordinates.

On screen, the canvas is located at position (CanvasX, CanvasY), rendered
at scale (ScaleX, ScaleY).
]]
function canvas_to_screen(pos)
    assert(false, "'canvas_to_screen' - Not implemented")
    return pos
end


local PI = Constants.PI
local TWO_PI = Constants.TWO_PI


--[[
Transforms `angle`, in radians, to range [0, 2*pi]
]]
---@param angle number
---@return number
function angle_0_2pi(angle)
    while angle > TWO_PI do
        angle = angle - TWO_PI
    end
    while angle < 0 do
        angle = angle + TWO_PI
    end
    return angle
end


--[[
Transforms `angle`, in radians, to range [-pi, +pi]
]]
---@param angle number Angle in radians
---@return number # Angle in radians in range [-pi, +pi]
function angle_pi_pi(angle)
    while angle > PI do
        angle = angle - TWO_PI
    end
    while angle < -PI do
        angle = angle + TWO_PI
    end
    return angle
end


--[[
Transforms `angle` from radians to degrees.
]]
---@param angle number Angle in radians
---@return number # Angle in degrees
function to_degrees(angle)
    return angle*180/PI
end


--[[
Transforms `angle` from degrees to radians.
]]
---@param angle number Angle in degrees
---@return number # Angle in radians
function to_radians(angle)
    return angle*PI/180
end
