---@class TitleRoom: Object
---@operator call(): TitleRoom
TitleRoom = Object:extend()


---@param app GameApp
function TitleRoom:new(app)
    self.app = app

    self.title_rect = {
        x = 0, y = 240,
        w = 320, h = 80,
    }
    self.title_quad = love.graphics.newQuad(self.title_rect.x, self.title_rect.y, self.title_rect.w, self.title_rect.h, g_TextureAtlas)
    self.dev_rect = {
        x = 208, y = 192,
        w = 112, h = 48,
    }
    self.dev_quad = love.graphics.newQuad(self.dev_rect.x, self.dev_rect.y, self.dev_rect.w, self.dev_rect.h, g_TextureAtlas)

    self.background_rect = {
        x = 0, y = 96,
        w = 208, h = 144,
    }
    self.background_quad = love.graphics.newQuad(self.background_rect.x, self.background_rect.y, self.background_rect.w, self.background_rect.h, g_TextureAtlas)

    self.border_padding = 10

    self.show_title = true
end


function TitleRoom:init()
    self.show_title = true
end


function TitleRoom:update(dt)
end


function TitleRoom:render()
    if self.show_title then
        -- Background
        love.graphics.draw(g_TextureAtlas, self.background_quad, (VirtualWidth - 2*self.background_rect.w)/2, (VirtualHeight - 2*self.background_rect.h)/2, 0, 2, 2)
        -- Game title
        love.graphics.draw(g_TextureAtlas, self.title_quad, (VirtualWidth - self.title_rect.w)/2, self.border_padding)
        -- Developer
        love.graphics.draw(g_TextureAtlas, self.dev_quad, VirtualWidth - self.dev_rect.w - self.border_padding, VirtualHeight - self.dev_rect.h - self.border_padding)
        -- Play game
        love.graphics.printf("Press SPACE to play", 0, 0.9*VirtualHeight, VirtualWidth, "center")
    end
end


function TitleRoom:destroy()
end