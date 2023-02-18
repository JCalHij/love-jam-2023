-- https://stackoverflow.com/questions/65066037/how-to-debug-lua-love2d-with-vscode
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end


function love.load(args, unfiltered_args)
    require "core"
	require "game"

	input_init()

	-- Window
	love.graphics.setDefaultFilter("nearest", "nearest")
	WindowWidth, WindowHeight = love.window.getMode()
	VirtualWidth, VirtualHeight = 720, 480
	ScaleX, ScaleY = WindowWidth/VirtualWidth, WindowHeight/VirtualHeight
	CanvasX, CanvasY = 0, 0
	love.resize(WindowWidth, WindowHeight)
	MainCanvas = love.graphics.newCanvas(VirtualWidth, VirtualHeight)

	g_GameApp = GameApp()
end


function love.update(dt)
	g_GameApp:update(dt)
end


function love.draw()
    love.graphics.setCanvas(MainCanvas)
    love.graphics.setBlendMode('alpha', "alphamultiply")
    love.graphics.clear({0.3, 0.5, 1.0, 1.0})
    g_GameApp:render()
    love.graphics.setCanvas()

    SetDrawColor({1, 1, 1, 1})
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.clear({0.1, 0.1, 0.1, 1})
    love.graphics.draw(MainCanvas, CanvasX, CanvasY, 0, ScaleX, ScaleY)
end


function love.run()
    -- Initialize game
	love.load(love.arg.parseGameArguments(arg), arg)

	-- We don't want the first frame's dt to include time taken by love.load.
	love.timer.step()

	local dt = 0

	-- Main loop time.
	return function()
        local start = love.timer.getTime()
		-- Process events.
        input_cleanup_frame()
		love.event.pump()
		for name, a,b,c,d,e,f in love.event.poll() do
			if name == "quit" then
				if not love.quit or not love.quit() then
					return a or 0
				end
			end
			love.handlers[name](a,b,c,d,e,f)
		end

		dt = love.timer.step()
		love.update(dt)

		if love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear({0.3, 0.3, 0.3, 1.0})

			love.draw()

            g_DeltaTime = love.timer.getTime() - start
			love.graphics.present()
		end

		love.timer.sleep(0.001)
	end
end


function love.resize(x, y)
    WindowWidth, WindowHeight = x, y
    local tx = WindowWidth / VirtualWidth
    local ty = WindowHeight / VirtualHeight
    if tx > ty then
        ScaleX, ScaleY = ty, ty
        CanvasY = 0
        CanvasX = 0.5*(WindowWidth - ScaleX*VirtualWidth)
    else
        ScaleX, ScaleY = tx, tx
        CanvasX = 0
        CanvasY = 0.5*(WindowHeight - ScaleY*VirtualHeight)
    end
end