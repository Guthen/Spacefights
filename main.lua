love.window.setTitle( "Spacefights" )
love.window.setMode( 1280, 820 )

--  > Pixel-Art Filter
love.graphics.setDefaultFilter( "nearest" )

--  > Font
love.graphics.setFont( love.graphics.newFont( "assets/fonts/SMB2.ttf", 12 ) )

--  > Dependencies
require "lua.libs.require"
require "lua.libs.*"

--  > Game
require "lua.*"
require "lua.game.*"

function random_map_position()
    return math.random( MapW ), math.random( MapH )
end

--  > Framework
local slow_motion, slow_motion_factor, motion_time = false, .35, 1
function love.load()
    math.randomseed( os.time() )

    --  > Stars background
    local factor = 5
    local w, h = love.graphics.getDimensions()
    MapW = w * factor
    MapH = h * factor
    Stars( math.random( 250, 500 ) * 2, 0, 0, MapW, MapH )

    --  > Ship
    GamePlayer = Player( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )

    --  > Turret
    Turret( random_map_position() )
    local x, y = random_map_position()
    Turret( x, y, "dc-a" )

    --  > Power-Up
    for i = 1, 10 do
        PowerUp( "repair", random_map_position() )
    end
end

function love.update( dt )
    --  > Motion Controller
    motion_time = approach( dt, motion_time, slow_motion and slow_motion_factor or 1 )
    dt = dt * motion_time

    --  > Update Objects
    GameObjects.call( "update", dt )

    Camera:update( dt )

    --  > Timers
    for k, v in pairs( Timers ) do
        v.time = v.time + dt
        if v.time >= v.max_time then
            v.callback()
            Timers[k] = nil
        end
    end
end

function love.keypressed( key )
    if key == "r" then
        GameObjects.reset()
        love.load()
    elseif key == "g" then
        slow_motion = not slow_motion
    elseif key == "n" then
        GamePlayer.no_target = not GamePlayer.no_target
    end

    GameObjects.call( "keypress", key )
end

function love.mousepressed( x, y, button )
    GameObjects.call( "mousepress", button, x, y )
end

function love.draw()
    Camera:push()
    GameObjects.call( "draw" )
    Camera:pop()

    love.graphics.origin()
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( love.timer.getFPS() .. " FPS", 5, 5 )
    --love.graphics.print( GameObjects.count() .. " GO", 5, 20 )

    --  > HUD
    local w, h = love.graphics.getDimensions()
    local height = love.graphics.getFont():getHeight()

    local limit = 200
    love.graphics.printf( "TIME  x" .. round( motion_time, 2 ), w - 5 - limit, h - height - 5, limit, "right" )
    love.graphics.printf( "NOTARGET  " .. ( GamePlayer.no_target and "ON" or "OFF" ), w - 5 - limit, h - height * 2.2 - 5, limit, "right" )
end