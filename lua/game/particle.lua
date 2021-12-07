Particle = class( GameObject )
Particle.color = WHITE
Particle.x, Particle.y = 0, 0
Particle.radius = 15

function Particle:init( x, y, radius, color, life_time )
    self.x = x or self.x
    self.y = y or self.y
    self.radius = radius or self.radius
    self.color = color or self.color
    self.life_time = life_time or self.radius / 100

    self.radius_lose_psecond = self.radius / self.life_time
end

function Particle:update( dt )
    self.life_time = self.life_time - dt
    self.radius = lerp( 1 / self.life_time * dt, self.radius, 0 )
    if self.life_time <= 0 then
        self:destroy()
    end
end

function Particle:draw()
    love.graphics.setColor( math.floor( self.radius ) % 2 == 0 and self.color or WHITE )
    love.graphics.circle( "fill", self.x, self.y, self.radius )
end