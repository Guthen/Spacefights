local path, types = "lua/ships", {}
for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
    local file = v:gsub( "%.%w+$", "" )
    local obj = require( path .. "/" .. file )
    if not ( obj.controlable == false ) then
        types[#types + 1] = file
        print( "New controlable ship: " .. file )
    end
end

Ship, Ships = class( GameObject ), {}

Ship.x, Ship.y = 0, 0
Ship.vel_x, Ship.vel_y = 0, 0

Ship.name = nil
Ship.health = 10
Ship.kills = 0

Ship.turn_speed = 150
Ship.max_speed = 8
Ship.move_speed = 20
Ship.brake_speed = 2

Ship.no_target = false

Ship.size_factor = 3
Ship.vel_ang, Ship.ang = 0, 0

Ship.icon = image( "icons/arrow.png" )
Ship.image = image( "fighter_a.png" )
Ship.thruster_quad_id, Ship.thruster_time, Ship.thruster_max_time = 1, 0, .2 
Ship.color = WHITE
Ship.bullet_color = Ship.color

Ship.guns = {}

Ship.sounds = {
    shoot = {
        "ships/shoot01.wav",
        "ships/shoot02.wav",
        "ships/shoot03.wav",
    },
    hit = {
        "ships/hit01.wav",
        "ships/hit02.wav",
        "ships/hit03.wav",
    },
    destroy = {
        "ships/destroy01.wav",
        "ships/destroy02.wav",
        "ships/destroy03.wav",
    },
}

Ship.shader, Ship.shader_color = nil, Ship.color
Ship.hit_anim = 1

Ship.has_thruster = true
Ship.thruster = {
    x = 3,
    y = 7,
}

Ship.type = "starfighter"

function Ship:init( x, y, type )
    self.x, self.y = x or self.x, y or self.y

    --  > Load ship type
    self.type = type or types[math.random( #types )]

    local ship = table_copy( require( "lua.ships." .. self.type ) ) 
    for k, v in pairs( ship ) do
        self[k] = v
    end

    --  > Vars
    self.max_health = self.health
    self.color = table_copy( self.color )
    self.claimed = false
    self.vel_x, self.vel_y, self.vel_ang = 0, 0, 0
    self.ang = 0
    self.name = self.name or "N/A"

    --  > Repositionate guns
    self.guns = table_copy( self.guns )
    for i, v in ipairs( self.guns ) do
        v.x = v.x - 8
        v.y = v.y - 8
        v.cooldown = v.max_cooldown
    end

    --  > Thruster
    self.thruster = {
        x = self.thruster.x - 8,
        y = self.thruster.y - 8,
    }

    --  > Add to list
    Ships[self.id] = self
    HUD:addtarget( self, self.bullet_color, function( ship ) 
        return ship.health > 0 
    end, true )
end

function Ship:dead( killer )
    for i = 1, math.random( 3, 6 ) do
        timer( i / 25, function()
            Particle( self.x + math.random( -self.w, self.w ), self.y + math.random( -self.h, self.h ), math.min( i * self.w / 2, self.w * 2 ), self.bullet_color )
        end )
    end
end

function Ship:targetdead( target )
    self.kills = self.kills + 1
end

function Ship:emit( type )
    local sounds = self.sounds[type]
    if not sounds or #sounds <= 0 then return false end

    local volume = math.min( 1 / distance( self.x, self.y, GamePlayer.x, GamePlayer.y ) * 100, 1 )
    if volume > .1 then
        local source = love.audio.newSource( "assets/sounds/" .. sounds[math.random( #sounds )], "static" )
        source:setVolume( .5 )
        source:setPosition( self.x > GamePlayer.x and 1 or -1, self.y > GamePlayer.y and 1 or -1, 0 )
        source:play()
    end
end

function Ship:getspeed()
    return math.abs( self.vel_x ) + math.abs( self.vel_y )
end

function Ship:forward( dt, speed_factor )
    if self.move_speed <= 0 then return end
    if self:getspeed() >= self.max_speed then return false end

    self.vel_x = self.vel_x + math.cos( self.ang ) * dt * self.move_speed * speed_factor
    self.vel_y = self.vel_y + math.sin( self.ang ) * dt * self.move_speed * speed_factor
end

function Ship:getangdiff( target_ang )
    local ang_diff = self.ang - target_ang
    if math.abs( ang_diff ) > math.pi then
        if self.ang > target_ang then
            ang_diff = -1 * ( math.pi * 2 - self.ang + target_ang )
        else
            ang_diff = math.pi * 2 - target_ang + self.ang
        end
    end

    return ang_diff
end

function Ship:lookat( dt, x, y )
    local target_ang = direction_angle( self.x + self.w / 2, self.y + self.h / 2, x, y )

    --  > Calculate angle difference 
    --[[ https://jibransyed.wordpress.com/2013/09/05/game-maker-gradually-rotating-an-object-towards-a-target/ ]]
    local ang_diff = self:getangdiff( target_ang )

    --  > Gradually rotate
    self.ang = approach( dt * math.rad( self.turn_speed ), self.ang, self.ang - ang_diff )
end

function Ship:getchildpos( child )
    return 
        --[[ formula: https://www.gamedev.net/forums/topic/635908-how-do-i-rotate-a-group-of-child-objects-in-relation-to-a-parent-object/5011516/ ]]
        ( child.x * math.cos( self.ang ) - child.y * math.sin( self.ang ) ) * self.size_factor,
        ( child.x * math.sin( self.ang ) + child.y * math.cos( self.ang ) ) * self.size_factor
end

function Ship:getgunpos( id )
    local img_w, img_h = self.image:getDimensions()
    local gun = self.guns[id]

    local child_x, child_y = self:getchildpos( gun )
    return 
        self.x + self.w / 2 + child_x, 
        self.y + self.h / 2 + child_y
end

function Ship:fire( dt, type )
    local fired_guns = 0

    for i, v in ipairs( self.guns ) do
        if not v.dead and v.type == type then
            --  > Cooldown
            if v.cooldown > v.max_cooldown then 
                v.cooldown = 0
            
                --  > Bullet
                local bullet = type == "missile" and Missile() or Bullet()
                bullet.x, bullet.y = self:getgunpos( i )
                bullet.size_factor = self.size_factor
                bullet.ang = self.ang
                bullet.color = self.bullet_color
                bullet.shooter = self

                --  > Sound
                self:emit( "shoot" )

                fired_guns = fired_guns + 1
            end
        end
    end

    --  > Knockback
    if fired_guns > 0 and self.move_speed > 0 then
        local ang = self.ang - math.pi
        self.vel_x = self.vel_x + math.cos( ang ) * dt * self.move_speed * fired_guns / 2
        self.vel_y = self.vel_y + math.sin( ang ) * dt * self.move_speed * fired_guns / 2
    end
end

function Ship:hit( dt, dmg, x, y, color )
    if self.health > 0 then
        --  > Damage
        self.health = self.health - dmg
        if self.health <= 0 then
            --[[ timer( 1, function()
                self:destroy()
            end )  ]]
            self:emit( "destroy" )
        end

        --  > Visual effect
        self.shader = Shaders.HIT
        self.shader_color = color or WHITE

        timer( .15, function()
            self.shader = nil
        end, tostring( self ) .. "_shader" )
    end
    
    --  > Sound
    self:emit( "hit" )

    if self.move_speed > 0 then
        --  > Knockback
        local knockback_factor = ( self.health <= 0 and 2 or 1 ) * dmg
        local ang = direction_angle( self.x + self.w / 2, self.y + self.h / 2, x, y ) - math.pi
        self.vel_x = self.vel_x + math.cos( ang ) * dt * self.move_speed * knockback_factor
        self.vel_y = self.vel_y + math.sin( ang ) * dt * self.move_speed * knockback_factor
        
        --  > Angle deviation
        local is_left = self.x + self.w / 2 - x > 0
        if is_left then
            self.vel_ang = self.vel_ang - dt * knockback_factor
        else
            self.vel_ang = self.vel_ang + dt * knockback_factor
        end
    end
end

function Ship:update( dt )
    --  > Position update
    self.x = self.x + self.vel_x * dt * 60
    self.y = self.y + self.vel_y * dt * 60
    self.ang = self.ang + self.vel_ang * dt * 60

    --  > Velocity loss
    if self.brake_speed > 0 then
        local factor = self.health > 0 and 1 or .1
        self.vel_x = lerp( dt * self.brake_speed * factor, self.vel_x, 0 )
        self.vel_y = lerp( dt * self.brake_speed * factor, self.vel_y, 0 )
        self.vel_ang = lerp( dt * self.brake_speed * factor, self.vel_ang, 0 )
    end

    --  > Size
    local img_w, img_h = self.image:getDimensions()
    self.w, self.h = self.size_factor * img_w, self.size_factor * img_h

    --  > Cooldown
    for i, v in ipairs( self.guns ) do
        v.cooldown = v.cooldown + dt
    end

    --  > Hit Animation
    self.hit_anim = lerp( dt * ( self.shader and 10 or 5 ), self.hit_anim, self.shader and 1.5 or 1 )

    --  > Thruster
    if self.health > 0 then
        if self.has_thruster then
            self.thruster_time = self.thruster_time + dt
            if self.thruster_time >= self.thruster_max_time then
                self.thruster_quad_id = self.thruster_quad_id + 1 > ( self.is_moving and 3 or 6 ) and ( self.is_moving and 1 or 4 ) or self.thruster_quad_id + 1
                self.thruster_time = 0
            end
        end
    --  > Die
    else
        self.color[4] = approach( dt / 5, self.color[4] or 1, 0 )
        if self.color[4] <= 0 then
            self.color[4] = 1
            self:init( random_map_position() )
        end
    end
end

local thruster = image( "particles/thruster.png" )
local thruster_quads = quads( thruster, 7 )
function Ship:draw()
    --  > Thruster
    if self.has_thruster then
        love.graphics.setColor( 1, 1, 1 )
        if self.health > 0 then
            local w = thruster:getWidth()
            local child_x, child_y = self:getchildpos( self.thruster )
            local quad = thruster_quads[self.thruster_quad_id]
            love.graphics.draw( thruster, quad, self.x + self.w / 2 + child_x - math.cos( self.ang ) * ( w - 7 * self.size_factor ), self.y + self.h / 2 + child_y - math.sin( self.ang ) * ( w - 7 * self.size_factor ), self.ang, self.size_factor, self.size_factor, 0, 0 )
        end
    end
    
    --  > Ship
    if self.shader then
        love.graphics.setColor( self.shader_color )
        love.graphics.setShader( self.shader )
    else
        love.graphics.setColor( self.color )
    end

    love.graphics.draw( self.image, self.x + self.w / 2, self.y + self.h / 2, self.ang, self.size_factor, self.size_factor, self.w / self.size_factor / 2, self.h / self.size_factor / 2 )

    if self.shader then
        love.graphics.setShader()
    end

    --love.graphics.rectangle( "line", self.x, self.y, self.w, self.h )

    --[[ love.graphics.setColor( self.bullet_color )
    for i, v in ipairs( self.guns ) do
        local x, y = self:getgunpos( i )
        love.graphics.line( x, y, x + math.cos( self.ang ) * Bullet.max_destroy_time * Bullet.move_speed, y + math.sin( self.ang ) * Bullet.max_destroy_time * Bullet.move_speed )
    end ]]
end

function Ship:destroy()
    GameObject.destroy( self )
    Ships[self.id] = nil
end