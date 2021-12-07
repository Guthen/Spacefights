--  pixel-art filter
love.graphics.setDefaultFilter( "nearest" )

--  global variables
DEBUG = false
SCR_W, SCR_H = 1280, 720

Fonts = {
    NORMAL = love.graphics.newFont( "assets/fonts/SMB2.ttf", 12 ),
    BIG = love.graphics.newFont( "assets/fonts/SMB2.ttf", 16 ),
    ENORMOUS = love.graphics.newFont( "assets/fonts/SMB2.ttf", 24 ),
}

VERSION = "v1.0.0"

--  dependencies
require "lua.libs.require"
require "lua.libs.*"
require "lua.game.*"
require "lua.scenes.*"
require "lua.*"

function random_map_position()
    return math.random( MapW ), math.random( MapH )
end

--  framework
local slow_motion, slow_motion_factor, motion_time = false, .35, 1
function love.load()
    love.graphics.setFont( Fonts.NORMAL )
    love.window.setMode( SCR_W, SCR_H )
    love.window.setTitle( "Spacefights" )

    math.randomseed( os.time() )
    love.setScene( Game )
end

function love.setScene( scene, ... )
    if love._scene then GameObjects.reset() end

    local args = { ... }
    timer( 0, function() 
        love._scene = scene( unpack( args ) )
    end )
end

function love.update( dt )
    --  motion controller
    motion_time = approach( dt, motion_time, slow_motion and slow_motion_factor or 1 )
    dt = dt * motion_time

    --  timers
    for k, v in pairs( Timers ) do
        v.time = v.time + dt
        if v.time >= v.max_time then
            v.callback()
            Timers[k] = nil
        end
    end

    --  update objects
    GameObjects.call( "update", dt )
    GameObjects.sort( function( a, b )
        return ( a.z_index or 0 ) > ( b.z_index or 0 ) 
    end )

    Camera:update( dt )
end

function love.keypressed( key )
    if key == "r" then
        GameObjects.reset()
        love.load()
    elseif key == "," then
        DEBUG = not DEBUG
    end

    if DEBUG then
        if key == "g" then
            slow_motion = not slow_motion
        elseif key == "n" then
            GamePlayer.no_target = not GamePlayer.no_target
        end
    end

    GameObjects.call( "keypress", key )
end

function love.mousepressed( x, y, button )
    GameObjects.call( "mousepress", button, x, y )
end

function love.draw()
    Camera:push()
    GameObjects.callSorted( "draw" )
    Camera:pop()
    
    --  debug
    love.graphics.origin()
    love.graphics.setColor( WHITE )
    love.graphics.print( love.timer.getFPS() .. " FPS", 5, 5 )

    if DEBUG then
        love.graphics.print( "#Entities: " .. table_count( GameObjects ), 5, 25 )

        --  HUD
        local height = love.graphics.getFont():getHeight()
    
        local limit = 200
        love.graphics.printf( "TIME  x" .. round( motion_time, 2 ), SCR_W - 5 - limit, SCR_H - height - 5, limit, "right" )
        love.graphics.printf( "NOTARGET  " .. ( GamePlayer.no_target and "ON" or "OFF" ), SCR_W - 5 - limit, SCR_H - height * 2.2 - 5, limit, "right" )
    end
end