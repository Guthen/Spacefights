Particle = class( GameObject )
Particle.color = WHITE
Particle.x, Particle.y = 0, 0
Particle.radius = 15

function Particle:init( x, y, radius, color )
    self.x = x or self.x
    self.y = y or self.y
    self.radius = radius or self.radius
    self.color = color or self.color
end

function Particle:update( dt )
    self.radius = lerp( dt * 10, self.radius, 0 )
    if self.radius <= 1 then
        self:destroy()
    end
end

function Particle:draw()
    love.graphics.setColor( math.floor( self.radius ) % 2 == 0 and self.color or WHITE )
    love.graphics.circle( "fill", self.x, self.y, self.radius )
end