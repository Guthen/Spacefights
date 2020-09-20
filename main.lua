love.window.setTitle( "Spacefights" )

--  > Pixel-Art Filter
love.graphics.setDefaultFilter( "nearest" )

--  > Dependencies
require "lua.libs.class"
require "lua.libs.timer"
require "lua.libs.util"
require "lua.libs.gameobjects"

--  > Game
require "lua.shaders"
require "lua.game.camera"
require "lua.game.stars"
require "lua.game.bullet"
require "lua.game.missile"
require "lua.game.ship"
require "lua.game.shipai"
require "lua.game.player"


--  > Framework
function love.load()
    math.randomseed( os.time() )

    --  > Ship
    GamePlayer = Player( love.graphics.getWidth() * .25, love.graphics.getHeight() / 2 )
    ShipAI( 500, 500 )
    ShipAI( 500, 750 )
    ShipAI( 500, 250 )
    ShipAI( 500, 0 )

    --  > Stars background
    local factor = 5
    local w, h = love.graphics.getDimensions()
    w = w * factor
    h = h * factor
    Stars( math.random( 250, 500 ) * 2, -w / 2, -h / 2, w, h )
end

function love.update( dt )
    GameObjects.call( "update", dt )

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
        GameObjects.call( "destroy" )
        love.load()
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
    love.graphics.print( GameObjects.count() .. " GO", 5, 20 )
end