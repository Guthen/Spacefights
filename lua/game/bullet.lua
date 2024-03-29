Bullet = class( GameObject )
Bullet.x, Bullet.y = 0, 0
Bullet.ang = 0

Bullet.move_speed = 1000
Bullet.destroy_time, Bullet.max_destroy_time = 0, 3

Bullet.size_factor = 2

Bullet.damage = .5
Bullet.shooter = nil

Bullet.image = image( "bullet.png" )
Bullet.color = WHITE

Bullet.particle_size_kill = 35
Bullet.particle_size_hit = 15

function Bullet:init( x, y, size_factor, ang )
    self.x, self.y = x or self.x, y or self.y

    self.size_factor = size_factor or self.size_factor
    self.ang = ang or self.ang
end

function Bullet:hit( target )
    self:destroy()

    --  > Kill
    if target.health <= 0 and not target.claimed then
        self.shooter:on_target_death( target )
        target:on_death( self.shooter )
        target.claimed = true
    end

    --  > Particle
    Particle( self.x, self.y, ( target.health <= 0 and not target.claimed ) and self.particle_size_kill or self.particle_size_hit, self.shooter.bullet_color )
end

function Bullet:update( dt )
    --  > Random speed-boost
    local speed_boost = 1 + math.random() / 5

    --  > Move forward
    self.x = self.x + math.cos( self.ang ) * dt * self.move_speed * speed_boost
    self.y = self.y + math.sin( self.ang ) * dt * self.move_speed * speed_boost

    --  > Destroy
    self.destroy_time = self.destroy_time + dt
    if self.destroy_time >= self.max_destroy_time then
        Particle( self.x, self.y, self.particle_size_hit / 2, self.shooter.bullet_color )
        self:destroy()
        return
    end

    --  > Ships collision
    local img_w, img_h = self.image:getDimensions()
    local size = math.max( img_w, img_h ) * self.size_factor / 2
    for k, v in pairs( Ships ) do
        if not ( v == self.shooter ) then
            if collide( self.x, self.y, size, size, v.x, v.y, v.w, v.h ) then
                v:hit( dt, self.damage, self.x, self.y )
                self:hit( v )
            end
        end
    end
end

function Bullet:draw()
    love.graphics.setColor( self.color )

    local img_w, img_h = self.image:getDimensions()
    love.graphics.draw( self.image, self.x, self.y, self.ang, self.size_factor, self.size_factor, img_w / 2, img_h / 2 )
    
    --love.graphics.rectangle( "line", self.x, self.y, self.size_factor * img_w, self.size_factor * img_h )
end