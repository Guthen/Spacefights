require "lua.game.ship"

Player = class( Ship )

Player.name = "PLAYER"
Player.type = "starfighter"

Player.notifications = {}

function Player:dead( killer )
    self.notifications[#self.notifications + 1] = {
        icon = killer.icon,
        color = killer.bullet_color,
        text = ( "KILLED BY %s" ):format( killer.name ),
        time = 5,
        scale = 0,
    }

    Camera:shake( 7 )
    Ship.dead( self, killer )
end

function Player:targetdead( target )
    self.notifications[#self.notifications + 1] = {
        icon = target.icon,
        color = target.bullet_color,
        text = ( "KILLED %s" ):format( target.name ),
        time = 5,
        scale = 0,
    }

    Ship.targetdead( self, target )
end

function Player:hit( dt, dmg, x, y, color )
    Camera:shake( dmg )
    Ship.hit( self, dt, dmg, x, y, color )
end

function Player:update( dt )
    Ship.update( self, dt )

    --  > Camera
    Camera:centerat( self.x + self.w / 2, self.y + self.h / 2 )

    --  > Notifications
    for i, v in ipairs( self.notifications ) do
        v.max_time = v.max_time or v.time
        v.scale = lerp( dt * 3, v.scale, v.time > v.max_time * .25 and 1 or 0 )

        v.time = v.time - dt
        if v.time <= 0 then
            table.remove( self.notifications, i )
        end
    end

    --  > Again, not big surprise
    if self.health <= 0 then return end

    --  > Move
    self.is_moving = false
    if love.keyboard.isDown( "z" ) then
        self:forward( dt, 1 )
        self.is_moving = true
    end
    if love.keyboard.isDown( "s" ) then
        self:forward( dt, -.5 )
        self.is_moving = true
    end
    
    --  > Turn ship towards mouse
    local m_x, m_y = love.mouse.getPosition()
    m_x = Camera.x + m_x
    m_y = Camera.y + m_y
    self:lookat( dt, m_x, m_y )

    --  > Fire
    if love.mouse.isDown( 1 ) then
        self:fire( dt, "primary" )
        Camera:shake( 1 )
    end
    if love.mouse.isDown( 2 ) then
        self:fire( dt, "missile" )
        Camera:shake( 2 )
    end
end

function Player:draw()
    --  > Ship
    Ship.draw( self )
    
    --  > HUD
    HUD:draw( self )
end