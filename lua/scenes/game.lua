Game = class( GameObject )

function Game:init()
    --  stars background
    local factor = 5
    MapW = SCR_W * factor
    MapH = SCR_H * factor
    Stars( math.random( 250, 500 ) * 2, 0, 0, MapW, MapH )

    --  ship
    GamePlayer = Player( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )
    ShipAI( random_map_position() )

    --  turret
    Turret( random_map_position() )
    local x, y = random_map_position()
    Turret( x, y, "dc-a" )

    --  power-up
    for i = 1, 10 do
        PowerUp( "repair", random_map_position() )
    end

    --  refresh entities
    --GameObjects.call( "update", love.timer.getDelta() )
end

function Game:update( dt )
end

function Game:keypress( key )
    if key == "escape" then
        love.setScene( Menu )
    end
end

function Game:draw()
    love.graphics.print( "Game Scene", 5, 45 )
end