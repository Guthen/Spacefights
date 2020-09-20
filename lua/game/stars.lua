Stars = class( GameObject )
Stars.stars = {}

function Stars:init( amount, x, y, w, h )
    for i = 0, amount do
        self.stars[#self.stars + 1] = {
            x = x + math.random( w ),
            y = y + math.random( h ),
            size = math.random( 1, 3 ),
            alpha = math.random(),
        }
    end
end

function Stars:draw()
    for i, v in ipairs( self.stars ) do
        love.graphics.setColor( 1, 1, 1, v.alpha )
        love.graphics.rectangle( "fill", v.x, v.y, v.size, v.size )
    end
end