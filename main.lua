if (jit.arch == 'arm64' or jit.arch == 'arm') then jit.off() end


require "engine/object"
require "bit"
require "engine/string_packer"
require "engine/controller"
require "back"
require "tag"
require "engine/event"
require "engine/node"
require "engine/moveable"
require "engine/sprite"
require "engine/animatedsprite"
require "functions/misc_functions"
require "game"
require "globals"
require "engine/ui"
require "functions/UI_definitions"
require "functions/state_events"
require "functions/common_events"
require "functions/button_callbacks"
require "functions/misc_functions"
require "functions/test_functions"
require "card"
require "cardarea"
require "blind"
require "card_character"
require "engine/particles"
require "engine/text"
require "challenges"
require "mods/Always_Show_Seed"
require "mods/Talisman/talisman"

-- imbored mod (Android stub)
require "mods/imbored/smods_stub"
-- atlases
require "mods/imbored/main_atlases"
-- rarities and boosters (no-ops via stub)
require "mods/imbored/rarities"
require "mods/imbored/boosters"
-- jokers (in original load order from jokerIndexList)
require "mods/imbored/jokers/pulsesog"
require "mods/imbored/jokers/sowee"
require "mods/imbored/jokers/eviljoker"
require "mods/imbored/jokers/fish"
require "mods/imbored/jokers/you_know"
require "mods/imbored/jokers/aahahahahhahahha"
require "mods/imbored/jokers/holycrackers"
require "mods/imbored/jokers/gex"
require "mods/imbored/jokers/bullseye"
require "mods/imbored/jokers/soniccdspritefromtheprototype"
require "mods/imbored/jokers/_3"
require "mods/imbored/jokers/parttheseas"
require "mods/imbored/jokers/scentedjoker"
require "mods/imbored/jokers/ruinedjoker"
require "mods/imbored/jokers/thebeachthatmakesyouold"
require "mods/imbored/jokers/horizontaljoker"
require "mods/imbored/jokers/nsfj"
require "mods/imbored/jokers/bulletedjoker"
require "mods/imbored/jokers/wegajoker"
require "mods/imbored/jokers/whofarted"
require "mods/imbored/jokers/thelonelyjoker"
require "mods/imbored/jokers/pacman"
require "mods/imbored/jokers/blindfoldedjoker"
require "mods/imbored/jokers/scaredjoker"
require "mods/imbored/jokers/alternatejoker"
require "mods/imbored/jokers/suspiciouslypurplejoker"
require "mods/imbored/jokers/rtxjoker"
require "mods/imbored/jokers/meltedjoker"
-- consumables (sets first, then cards)
require "mods/imbored/consumables/sets"
require "mods/imbored/consumables/supersmashbrosmelee"
require "mods/imbored/consumables/wegacard"
-- enhancements
require "mods/imbored/enhancements/circus"
-- seals
require "mods/imbored/seals/cardprotector"
-- editions
require "mods/imbored/editions/evil"
-- vouchers
require "mods/imbored/vouchers/fuck_that_cloud"
require "mods/imbored/vouchers/you_shouldnt_have_bought_that_cloud_hater"
-- decks
require "mods/imbored/decks/hey_look_its_a_joker_wow"
require "mods/imbored/decks/i_think_its_antimatter_deck"
require "mods/imbored/decks/wega"
require "mods/imbored/decks/circus_deck"

math.randomseed( G.SEED )

local function load_external_mods()
    local mods_path = "/storage/emulated/0/Balatro/mods"
    os.execute('mkdir -p "' .. mods_path .. '"')
    if not love.filesystem.mount(mods_path, "ext_mods") then return end
    local ok, items = pcall(love.filesystem.getDirectoryItems, "ext_mods")
    if not ok or type(items) ~= "table" then return end
    for _, fname in ipairs(items) do
        if fname:sub(-4) == ".lua" then
            pcall(function()
                local chunk = love.filesystem.load("ext_mods/" .. fname)
                if chunk then pcall(chunk) end
            end)
        else
            local info = love.filesystem.getInfo("ext_mods/" .. fname)
            if info and info.type == "directory" then
                local mod_id  = fname:match("^([^%-]+)") or fname
                local mod_vfs = "ext_mods/" .. fname .. "/"
                -- Set current_mod so SMODS.Atlas / SMODS.Joker use right prefix
                SMODS.current_mod = {
                    id   = mod_id,
                    path = mod_vfs,
                    config = {},
                    save_mod_config = function() end,
                    load_mod_config = function() end,
                }
                -- Try common entry points
                local base = mod_id
                for _, ep in ipairs({"main.lua", fname..".lua", base..".lua"}) do
                    if love.filesystem.getInfo(mod_vfs .. ep) then
                        pcall(function()
                            local chunk = love.filesystem.load(mod_vfs .. ep)
                            if chunk then pcall(chunk) end
                        end)
                        break
                    end
                end
                -- Register any jokers/atlases this mod declared
                if SMODS and SMODS._register_new then SMODS._register_new() end
            end
        end
    end
    -- Restore imbored as current mod
    SMODS.current_mod = { id="imbored", path="mods/imbored/", config={},
        save_mod_config=function() end, load_mod_config=function() end }
end

local isTvOs = false

if love.system.getPlatform then
	isTvOs = love.system.getPlatform() == "tvos"
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
	
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
	
	local dt = 0
	local dt_smooth = 1/100
	local run_time = 0
	local draw_lap = 0
	local hard_frame_cap = nil

	-- Main loop time.
	return function()
		run_time = love.timer.getTime()
		-- Process events.
		if love.event and G and G.CONTROLLER then
			love.event.pump()
			local _n,_a,_b,_c,_d,_e,_f,touched
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" and love.system.getOS() ~= 'iOS' then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				if name == 'touchpressed' then
					touched = true
				elseif name == 'mousepressed' then 
					_n,_a,_b,_c,_d,_e,_f = name,a,b,c,d,e,f
				else
					love.handlers[name](a,b,c,d,e,f)
				end
			end
			if _n then 
				love.handlers['mousepressed'](_a,_b,_c,touched)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
		dt_smooth = math.min(0.8*dt_smooth + 0.2*dt, 0.1)
		-- Call update and draw
		if love.update then love.update(dt_smooth) end -- will pass 0 if love.timer is disabled
	
		G.FPS_CAP = G.FPS_CAP or (G.F_MOBILE and 60 or 200)

		if love.graphics and love.graphics.isActive() then
			if love.draw then love.draw() end
			nuGC(nil, nil, true)
			local sleep_time = 1/G.FPS_CAP - (love.timer.getTime() - draw_lap)
			if sleep_time > 0.001 then 
				love.timer.sleep(sleep_time)
			end
			draw_lap = love.timer.getTime()
			love.graphics.present()
		end

		run_time = math.min(love.timer.getTime() - run_time, 0.1)
		if run_time > 0.0001 and run_time < 1./G.FPS_CAP then love.timer.sleep(1./G.FPS_CAP - run_time) end
	end
end

local started = false
local splashVideo = nil
local scaleX, scaleY

local getSplashVideoFileName = function()
	local videos = {
        { aspect = 16/10.5, resolution = 0, file = "16x10.5_Landscape.ogv" },
        { aspect = 16/10, resolution = 2880, file = "16x10_Landscape_2880.ogv" },
        { aspect = 16/9, resolution = 2560, file = "16x9_Landscape_2560.ogv" },
        { aspect = 16/9, resolution = 5120, file = "16x9_Landscape_5120.ogv" },
        { aspect = 3/2, resolution = 0, file = "3x2_Landscape.ogv" },
        { aspect = 4.6/3, resolution = 0, file = "4.6x3_Landscape.ogv" },
        { aspect = 16/10, resolution = 1440, file = "16x10_Landscape_1440.ogv" },
        { aspect = 16/9, resolution = 1920, file = "16x9_Landscape_1920.ogv" },
        { aspect = 16/9, resolution = 4096, file = "16x9_Landscape_4096.ogv" },
        { aspect = 19.5/9, resolution = 0, file = "19.5x9_Landscape.ogv" },
        { aspect = 4.3/3, resolution = 0, file = "4.3x3_Landscape.ogv" },
        { aspect = 4/3, resolution = 0, file = "4x3_Landscape.ogv" }
    }

    -- Current window size
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local currentAspect = screenWidth / screenHeight

    -- Find the closest aspect ratio and appropriate resolution
    local bestMatch = nil
    local minDifference = math.huge
    for _, video in ipairs(videos) do
        local difference = math.abs(video.aspect - currentAspect)
        if difference < minDifference then
            minDifference = difference
            bestMatch = video
        elseif difference == minDifference then
            if video.resolution == 0 or (video.resolution >= screenWidth and (bestMatch.resolution == 0 or video.resolution < bestMatch.resolution)) then
                bestMatch = video
            elseif video.resolution < screenWidth and video.resolution > bestMatch.resolution then
                bestMatch = video
            end
        end
    end

    -- Output the best match
    --print("Best matching splash video file: " .. bestMatch.file)
	return bestMatch.file
end

function love.load()

	splashVideo = nil
	
	G:init_window()

	if love.platform.earlyInit then
		love.platform.earlyInit()
	end

	if love.platform.isArcade and love.platform.isArcade() then
		splashVideo = love.graphics.newVideo("resources/videos/"..getSplashVideoFileName())
	end

	if splashVideo then
		shouldSplash = true
		-- Calculate scaling factors
		scaleX = love.graphics.getWidth() / splashVideo:getWidth()
		scaleY = love.graphics.getHeight() / splashVideo:getHeight()
	else
		G:start_up()
		if SMODS and SMODS._init then SMODS._init() end
		load_external_mods()
		started = true
	end

	--Set the mouse to invisible immediately, this visibility is handled in the G.CONTROLLER
	love.mouse.setVisible(false)
end

function love.quit()
	--Steam integration
	if G.SOUND_MANAGER then G.SOUND_MANAGER.channel:push({type = 'stop'}) end
	if G.STEAM then G.STEAM:shutdown() end
end

function love.update( dt )

	if shouldSplash then
		love.platform.hideSplashScreen()
		splashVideo:play()
		shouldSplash = false
		
	end

	if started then
		--Perf monitoring checkpoint
		timer_checkpoint(nil, 'update', true)
		G:update(dt)
	end
end

function love.draw()

	if splashVideo and not shouldSplash then
		-- Center the video on the screen
		love.graphics.push()
		love.graphics.scale(scaleX, scaleY)
		love.graphics.draw(splashVideo, 0, 0)
		love.graphics.pop()

		love.event.pump()
		if not splashVideo:isPlaying() or (love.platform.anyButtonPressed() and not love.platform.isFirstTimePlaying()) then
			G:start_up()
			if SMODS and SMODS._init then SMODS._init() end
			load_external_mods()
			started = true
			splashVideo = nil
		end
	end

	if started then
		--Perf monitoring checkpoint
		timer_checkpoint(nil, 'draw', true)
		G:draw()
	end
end

function love.keypressed(key)

	if isTvOs then
		if key == "right" or key == "left" or key == "up" or key == "down" then
			love.gamepadpressed(G.CONTROLLER.keyboard_controller, "dp"..key)
			return
		end
	end

	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadpressed(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_press(key)
	end
end

function love.keyreleased(key)

	if isTvOs then
		if key == "right" or key == "left" or key == "up" or key == "down" then
			love.gamepadreleased(G.CONTROLLER.keyboard_controller, "dp"..key)
			return
		end
	end

	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadreleased(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_release(key)
	end
end

function love.gamepadpressed(joystick, button)
	button = G.button_mapping[button] or button
	G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

function love.mousepressed(x, y, button, touch)
    G.CONTROLLER:set_HID_flags(touch and 'touch' or 'mouse')
    if button == 1 then 
		G.CONTROLLER:queue_L_cursor_press(x, y)
	end
	if button == 2 then
		G.CONTROLLER:queue_R_cursor_press(x, y)
	end
end


function love.mousereleased(x, y, button)
    if button == 1 then G.CONTROLLER:L_cursor_release(x, y) end
end

function love.mousemoved(x, y, dx, dy, istouch)
	if isTvOs then
		return
	end

	G.CONTROLLER.last_touch_time = G.CONTROLLER.last_touch_time or -1
	if next(love.touch.getTouches()) ~= nil then
		G.CONTROLLER.last_touch_time = G.TIMERS.UPTIME
	end
    G.CONTROLLER:set_HID_flags(G.CONTROLLER.last_touch_time > G.TIMERS.UPTIME - 0.2 and 'touch' or 'mouse')
end

function love.joystickaxis( joystick, axis, value )
	if isTvOs and joystick:getName() == "Remote" then
		return
	end

	if math.abs(value) > 0.2 and joystick:isGamepad() then
		G.CONTROLLER:set_gamepad(joystick)
        G.CONTROLLER:set_HID_flags('axis')
    end
end

function love.errhand(msg)

	print(msg)
	
	if G.F_NO_ERROR_HAND then return end
	msg = tostring(msg)

	if G.SETTINGS.crashreports and _RELEASE_MODE and G.F_CRASH_REPORTS then 
		local http_thread = love.thread.newThread([[
			local https = require('https')
			CHANNEL = love.thread.getChannel("http_channel")

			while true do
				--Monitor the channel for any new requests
				local request = CHANNEL:demand()
				if request then
					https.request(request)
				end
			end
		]])
		local http_channel = love.thread.getChannel('http_channel')
		http_thread:start()
		local httpencode = function(str)
			local char_to_hex = function(c)
				return string.format("%%%02X", string.byte(c))
			end
			str = str:gsub("\n", "\r\n"):gsub("([^%w _%%%-%.~])", char_to_hex):gsub(" ", "+")
			return str
		end
		

		local error = msg
		local file = string.sub(msg, 0,  string.find(msg, ':'))
		local function_line = string.sub(msg, string.len(file)+1)
		function_line = string.sub(function_line, 0, string.find(function_line, ':')-1)
		file = string.sub(file, 0, string.len(file)-1)
		local trace = debug.traceback()
		local boot_found, func_found = false, false
		for l in string.gmatch(trace, "(.-)\n") do
			if string.match(l, "boot.lua") then
				boot_found = true
			elseif boot_found and not func_found then
				func_found = true
				trace = ''
				function_line = string.sub(l, string.find(l, 'in function')+12)..' line:'..function_line
			end

			if boot_found and func_found then 
				trace = trace..l..'\n'
			end
		end

		http_channel:push('https://958ha8ong3.execute-api.us-east-2.amazonaws.com/?error='..httpencode(error)..'&file='..httpencode(file)..'&function_line='..httpencode(function_line)..'&trace='..httpencode(trace)..'&version='..(G.VERSION))
	end

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

	love.graphics.clear(G.C.BLACK)
	love.graphics.origin()


	local p = 'Oops! Something went wrong:\n'..msg..'\n\n'..(not _RELEASE_MODE and ((G.CRASH_DEBUG or '')..'\n'..debug.traceback()) or G.SETTINGS.crashreports and
		'Since you are opted in to sending crash reports, LocalThunk HQ was sent some useful info about what happened.\nDon\'t worry! There is no identifying or personal information. If you would like\nto opt out, change the \'Crash Report\' setting to Off' or
		'Crash Reports are set to Off. If you would like to send crash reports, please opt in in the Game settings.\nThese crash reports help us avoid issues like this in the future')

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.push()
		love.graphics.clear(G.C.BLACK)
		love.graphics.setColor(1., 1., 1., 1.)
		love.graphics.printf(p, font, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.pop()
		love.graphics.present()

	end

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "escape" then
				return
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end

function love.resize(w, h)
	G.is_16_9 = math.abs(w/h - 16/9) < 0.01

	if w/h < 1 then --Dont allow the screen to be too square, since pop in occurs above and below screen
		h = w/1
	end

	--When the window is resized, this code resizes the Canvas, then places the 'room' or gamearea into the middle without streching it
	if w/h < G.window_prev.orig_ratio then
		G.TILESCALE = G.window_prev.orig_scale*w/G.window_prev.w
	else
		G.TILESCALE = G.window_prev.orig_scale*h/G.window_prev.h
	end

	if G.ROOM then
		G.ROOM.T.w = G.TILE_W
		G.ROOM.T.h = G.TILE_H
		G.ROOM_ATTACH.T.w = G.TILE_W
		G.ROOM_ATTACH.T.h = G.TILE_H		

		if w/h < G.window_prev.orig_ratio then
			G.ROOM.T.x = G.ROOM_PADDING_W
			G.ROOM.T.y = (h/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.h+G.ROOM_PADDING_H))/2 + G.ROOM_PADDING_H/2
		else
			G.ROOM.T.y = G.ROOM_PADDING_H
			G.ROOM.T.x = (w/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.w+G.ROOM_PADDING_W))/2 + G.ROOM_PADDING_W/2
		end

		G.ROOM_ORIG = {
            x = G.ROOM.T.x,
            y = G.ROOM.T.y,
            r = G.ROOM.T.r
        }

		if G.buttons then G.buttons:recalculate() end
		if G.HUD then G.HUD:recalculate() end
	end

	G.WINDOWTRANS = {
		x = 0, y = 0,
		w = G.TILE_W+2*G.ROOM_PADDING_W, 
		h = G.TILE_H+3*G.ROOM_PADDING_H,
		real_window_w = w,
		real_window_h = h
	}

	G.CANV_SCALE = 1

	G.CANVAS = love.graphics.newCanvas(w*G.CANV_SCALE, h*G.CANV_SCALE, {type = '2d', readable = true})
	G.CANVAS:setFilter('linear', 'linear')

	if G.STAGE == G.STAGES.RUN then
		set_screen_positions()
	end
end 
