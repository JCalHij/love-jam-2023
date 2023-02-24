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
        x = 1, y = 81,
        w = 158, h = 78,
    }
    self.background_quad = love.graphics.newQuad(self.background_rect.x, self.background_rect.y, self.background_rect.w, self.background_rect.h, g_TextureAtlas)

    self.border_padding = 10

    self.show_title = true
    self.show_tutorial = false

    self.show_title_advance_text = false
    self.show_tutorial_advance_text = false

    self.app.timer:after(2.0, function()
        self.show_title_advance_text = true
    end)
end


function TitleRoom:init()
    self.show_title = true
    self.show_tutorial = false
    self.show_title_advance_text = false
    self.show_tutorial_advance_text = false
end


function TitleRoom:update(dt)
    if self.show_title then
        if self.show_title_advance_text then
            if input_is_key_pressed("space") then
                self.show_title = false
                self.show_title_advance_text = false
                self.show_tutorial = true
                self.app.timer:after(2.0, function()
                    self.show_tutorial_advance_text = true
                end)
            end
        end
    elseif self.show_tutorial then
        if self.show_tutorial_advance_text then
            if input_is_key_pressed("space") then
                -- Move to GameplayRoom
                self.app:enter("gameplay")
            end
        end
    end
end


function TitleRoom:render()
    if self.show_title then
        -- Background
        love.graphics.draw(g_TextureAtlas, self.background_quad, (VirtualWidth - 4*self.background_rect.w)/2, (VirtualHeight - 4*self.background_rect.h)/2, 0, 4, 4)
        -- Game title
        love.graphics.draw(g_TextureAtlas, self.title_quad, (VirtualWidth - self.title_rect.w)/2, self.border_padding)
        -- Developer
        love.graphics.draw(g_TextureAtlas, self.dev_quad, VirtualWidth - self.dev_rect.w - self.border_padding, VirtualHeight - self.dev_rect.h - self.border_padding)
        -- Play game
        if self.show_title_advance_text then
            love.graphics.printf("Press SPACE to play", 0, 0.9*VirtualHeight, VirtualWidth, "center")
        end
    end

    if self.show_tutorial then
        -- Tutorial
        love.graphics.printf("TUTORIAL", 0, self.border_padding, VirtualWidth, "center")
        love.graphics.printf("1. Click on enemies to order the knight to kill them.", 0, 40, VirtualWidth, "center")
        love.graphics.printf("2. You can perform a chain attack by dragging the mouse over enemies while the mouse is being pressed.", 0, 80, VirtualWidth, "center")
        love.graphics.printf("3. Killing enemies nets you points. Chaining attacks gives you more points!", 0, 120, VirtualWidth, "center")
        love.graphics.printf("4. Chain attacks cannot be cancelled. Be careful when planning your attacks!", 0, 160, VirtualWidth, "center")
        love.graphics.printf("5. The magic shield protects the princess from harm, but it does not last forever!", 0, 200, VirtualWidth, "center")
        love.graphics.printf("6. When an enemy wave is finished, you can upgrade your knight. Choose wisely in what to spend your points!", 0, 240, VirtualWidth, "center")
        love.graphics.printf("Have Fun.", 0, 300, VirtualWidth, "center")
        -- Play game
        if self.show_tutorial_advance_text then
            love.graphics.printf("Press SPACE to play", 0, 0.9*VirtualHeight, VirtualWidth, "center")
        end
    end
end


function TitleRoom:destroy()
end