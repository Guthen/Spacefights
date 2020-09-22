Player = class( Ship )

Player.name = "PLAYER"
Player.type = "light_starfighter"

Player.notifications = {}

function Player:dead( killer )
    self.notifications[#self.notifications + 1] = {
        text = ( "KILLED BY %s" ):format( killer.name ),
        time = 2,
    }
end

function Player:targetdead( target )
    self.notifications[#self.notifications + 1] = {
        text = ( "KILLED %s" ):format( target.name ),
        time = 2,
    }

    Ship.targetdead( self, target )
end

function Player:update( dt )
    Ship.update( self, dt )

    --  > Camera
    Camera:centerat( self.x + self.w / 2, self.y + self.h / 2 )

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
    end
    if love.mouse.isDown( 2 ) then
        self:fire( dt, "missile" )
    end

    --  > Notifications
    for i, v in ipairs( self.notifications ) do
        v.time = v.time - dt
        if v.time <= 0 then
            table.remove( self.notifications, i )
        end
    end
end

function Player:draw()
    local w, h = love.graphics.getDimensions()

    --  > Ship
    Ship.draw( self )
    
    --  > HUD
    Camera:pop()
    
    local scores = {}
    for k, v in pairs( Ships ) do
        --  > Scores
        scores[#scores + 1] = {
            text = v.name,
            score = v.kills,
            is_player = v == self,
        }

        if v.health > 0 then
            --  > Ships positions hints
            if not collide( v.x + v.w / 2, v.y + v.h / 2, v.w, v.h, Camera.x, Camera.y, w, h ) then
                local ang, dist = direction_angle( self.x, self.y, v.x, v.y ), distance( v.x, v.y, self.x, self.y ) / self.size_factor
                local x, y = w / 2 + math.cos( ang ) * h * .25, h / 2 + math.sin( ang ) * h * .25
                local dist_factor = math.max( .5, math.max( 1 / dist * 100, .15 ) )

                love.graphics.setColor( v.bullet_color )
                love.graphics.printf( round( dist, 0 ), x - math.cos( ang ) * 100, y - math.sin( ang ) * 100, 200, "right", ang, 1.5 * dist_factor, 1.5 * dist_factor ) 
                love.graphics.draw( v.icon, x, y, ang, self.size_factor * dist_factor, self.size_factor * dist_factor )
            --  > Head UI
            else
                Camera:push()

                --  > Health Bar
                local bar_margin = 1
                local bar_w, bar_h = v.w + bar_margin * 2, v.h * .1 + bar_margin * 2
                local bar_gap = bar_h * 2
                love.graphics.setColor( 0, 0, 0 )
                love.graphics.rectangle( "fill", v.x, v.y - bar_gap, bar_w, bar_h )         
            
                love.graphics.setColor( v.bullet_color )
                love.graphics.rectangle( "fill", v.x + bar_margin, v.y + bar_margin - bar_gap, v.w * v.health / v.max_health, self.h * .1 )         
                
                --  > Name
                local limit = 250
                --love.graphics.setColor( 1, 1, 1 )
                love.graphics.printf( v.name, v.x + v.w / 2 - limit / 2, v.y - bar_gap * 2 - bar_h, limit, "center" )

                Camera:pop()
            end
        end
    end

    --  > Notifications
    local limit = 400
    love.graphics.setColor( 1, 1, 1 )
    for i, v in ipairs( self.notifications ) do
        love.graphics.printf( v.text, w / 2 - limit / 2, h * .6 + i * 20, limit, "center" )
    end

    --  > Scoreboard
    local limit = 200
    love.graphics.printf( "SCOREBOARD", w * .99 - limit, w * .01, limit, "right" )
    
    table.sort( scores, function( a, b )
        return a.score > b.score
    end )
    for i, v in ipairs( scores ) do
        love.graphics.setColor( v.is_player and self.bullet_color or { 1, 1, 1 } )
        love.graphics.printf( v.text .. "  " .. v.score, w * .99 - limit, w * .01 + 20 * i, limit, "right" )
    end

    --  > Health
    local health = math.floor( self.health / self.max_health * 100, 0 )
    love.graphics.setColor( health > 75 and { .2, 1, .2 } or health > 25 and { 1, 1, .2 } or { .75, .1, .1 } )
    love.graphics.print( ( "%s  %d%%" ):format( self.type:upper(), health ), w * .01, h * .8 - 45 )

    --  > Speed
    local speed = math.floor( self:getspeed() / self.max_speed * 100 )
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( ( "SPEED  %d%%" ):format( math.min( speed, 100 ) ), w * .01, h * .8 - 25 )

    --  > Kills
    love.graphics.print( ( "KILLS  %d" ):format( self.kills ), w * .01, h * .8 - 5 )

    --  > Guns status
    local count = {}
    for i, v in ipairs( self.guns ) do
        local ready = self.health > 0 and not v.dead and v.cooldown >= v.max_cooldown - .05
        love.graphics.setColor( ready and { .2, 1, .2 } or ( v.dead or self.health <= 0 ) and { .75, .1, .1 } or { 1, 1, 1 } )
        
        count[v.type] = ( count[v.type] or 0 ) + 1
        love.graphics.print( ( "%s %d  %s" ):format( v.type:upper(), count[v.type], ready and "READY" or ( v.dead or self.health <= 0 ) and "DEAD" or round( math.min( v.cooldown, v.max_cooldown ), 1 ) .. "s" ), w * .01, h * .8 + 20 * i )
    end

    Camera:push()
end