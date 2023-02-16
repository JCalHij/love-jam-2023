if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end


function love.load(args, unfiltered_args)
    require "core"
end


function love.update(dt)
end


function love.draw()
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