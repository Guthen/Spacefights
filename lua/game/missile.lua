Missile = class( Bullet )
Missile.default_ang = nil

Missile.move_speed = Bullet.move_speed * .5

Missile.damage = 5

Missile.image = image( "missile.png" )

Missile.particle_size_kill = 55
Missile.particle_size_hit = 35

function Missile:init( ... )
    Bullet.init( self, ... )

    self.func = math.random( 1, 2 ) == 1 and math.sin or math.cos
end

function Missile:hit( target )
    --  > Destroy guns
    for i, v in ipairs( target.guns ) do
        local dist = distance( target.x + v.x, target.y + v.y, self.x, self.y ) / self.size_factor
        if dist <= 16 then
            v.on_death = true
            break
        end
    end

    Bullet.hit( self, target )
end

function Missile:update( dt )
    self.default_ang = self.default_ang or self.ang

    self.ang = self.default_ang + self.func( self.destroy_time * 10 ) / 4
    Bullet.update( self, dt )
end