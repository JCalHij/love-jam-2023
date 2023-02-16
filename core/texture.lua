---@class Texture: Object
---@field resource userdata Image this texture uses as resource
---@field quads userdata[] List of rectangles (quads) the image can be divided into
Texture = Object:extend()

--[[

]]
---@param texture_def TextureDef
function Texture:new(texture_def)
    self.resource = love.graphics.newImage(texture_def.resource)
    local quad_def = texture_def.quads
    self.quads = Texture.generate_quads(self.resource, quad_def.qw, quad_def.qh, quad_def.dx, quad_def.dy, quad_def.x0, quad_def.y0)
end


--[[
Renders quad with given transformation parameters.
]]
---@param index number the quad index
---@param x number the x coordinate
---@param y number the y coordinate
---@param r? number the rotation
---@param sx? number the scale in the x coordinate
---@param sy? number the scale in the y coordinate
function Texture:render_quad(index, x, y, r, sx, sy)
    love.graphics.draw(self.resource, self.quads[index], x, y, r or 0, sx or 1, sy or 1)
end


--[[
Generates evenly distributed quads for given `image`
using `sizeX` and `sizeY` as the sizes for each quad.
`dx` and `dy` parameters are optional, and determine
the space between sprites in the spritemap.
`ox` and `oy` parameters are also optional, and determine
the offset from the top left corner of the texture
to start creating quads.
]]
---comment
---@param image userdata
---@param sizeX number
---@param sizeY number
---@param dx? number
---@param dy? number
---@param ox? number
---@param oy? number
---@return userdata[]
function Texture.generate_quads(image, sizeX, sizeY, dx, dy, ox, oy)
    local dx, dy = dx or 0, dy or 0
    local ox, oy = ox or 0, oy or 0
    local w, h = image:getDimensions()
    
    local quads = {}
    for y = oy, h-sizeY, sizeY+dy do
        for x = ox, w-sizeX, sizeX+dx do
            -- printf("(x,y) = (%d, %d) (w, h) = (%d, %d)", x, y, sizeX, sizeY)
            local quad = love.graphics.newQuad(x, y, sizeX, sizeY, w, h)
            table.insert(quads, quad)
        end
    end
    return quads
end