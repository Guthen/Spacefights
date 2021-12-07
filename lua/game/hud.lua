HUD = {}
HUD.z_index = 1
HUD.targets = {}

function HUD:add_target( target, color, can_draw, draw_head_ui )
    self.targets[target.id] = {
        target = target,
        color = color or target.bullet_color or WHITE,
        draw_head_ui = draw_head_ui,
        can_draw = can_draw or function( ship ) 
            return true
        end,
    }
end

function HUD:remove_target( target )
    self.targets[target.id] = nil
end

function HUD:draw( player )
    Camera:pop()
    love.graphics.translate( Camera:get_screen_shake_translation( 2 ) )
    
    local scores = {}
    for k, v in pairs( Ships ) do
        --  > Scores
        if not ( v.controlable == false ) then
            scores[#scores + 1] = {
                text = v.name,
                score = v.kills,
                is_player = v == player,
            }
        end
    end

    --  > Draw Targets
    for k, v in pairs( self.targets ) do
        if v.can_draw( v.target, player ) then
            --  > Ships positions hints
            if not collide( v.target.x, v.target.y, v.target.w, v.target.h, Camera.x, Camera.y, SCR_W, SCR_H ) then
                local ang, dist = direction_angle( player.x + player.w / 2, player.y + player.h / 2, v.target.x + v.target.w / 2, v.target.y + v.target.h / 2 ), distance( v.target.x, v.target.y, player.x, player.y ) / player.size_factor
                local x, y = SCR_W / 2 + math.cos( ang ) * SCR_H * .25, SCR_H / 2 + math.sin( ang ) * SCR_H * .25
                local dist_factor = math.min( math.max( 1 / dist * 250, .5 ), .85 ) * ( v.target.hit_anim or 1 )

                love.graphics.setColor( v.target.shader and WHITE or v.color )
                love.graphics.printf( round( dist, 0 ), x - math.cos( ang ) * 100, y - math.sin( ang ) * 100, 200, "right", ang, 1.5 * dist_factor, 1.5 * dist_factor ) 
                love.graphics.draw( v.target.icon, x, y, ang, player.size_factor * dist_factor, player.size_factor * dist_factor )
            --  > Head UI
            elseif v.draw_head_ui then
                Camera:push()

                --  > Health Bar
                local bar_margin = 1
                local bar_w, bar_h = math.min( v.target.w, v.target.h ) + bar_margin * 2, v.target.h * .1 + bar_margin * 2
                local bar_gap = bar_h * 2
                local x = v.target.x + v.target.w / 2 - bar_w / 2
                love.graphics.setColor( 0, 0, 0 )
                love.graphics.rectangle( "fill", x, v.target.y - bar_gap, bar_w, bar_h )         
            
                love.graphics.setColor( v.target.bullet_color )
                love.graphics.rectangle( "fill", x + bar_margin, v.target.y + bar_margin - bar_gap, bar_w * v.target.health / v.target.max_health, player.h * .1 )         
                
                --  > Name
                local limit = 250
                --love.graphics.setColor( 1, 1, 1 )
                love.graphics.printf( v.target.name, v.target.x + v.target.w / 2 - limit / 2, v.target.y - bar_gap * 2 - bar_h, limit, "center" )

                Camera:pop()
            end
        end
    end

    --  > Notifications
    local font, limit = love.graphics.getFont(), 400
    local x, y = SCR_W / 2, SCR_H * .6
    for i, v in ipairs( player.notifications ) do
        love.graphics.setColor( v.color or WHITE )

        local text_w, text_h = font:getWidth( v.text ), font:getHeight()
        y = y + text_h * v.scale * 1.25
        if v.icon then
            local icon_w = v.icon:getWidth()
            love.graphics.draw( v.icon, x - text_w / 2 - text_h * 1.25 * v.scale, y, 0, text_h / icon_w * v.scale, nil, icon_w / 2, icon_w / 2 )
        end

        love.graphics.printf( v.text, x, y, limit, "left", 0, v.scale, v.scale, text_w / 2, text_h / 2 )
    end

    --  > Scoreboard
    local limit = 200
    love.graphics.setColor( WHITE )
    love.graphics.printf( "SCOREBOARD", SCR_W * .99 - limit, SCR_W * .01, limit, "right" )
    
    table.sort( scores, function( a, b )
        return a.score > b.score
    end )
    for i, v in ipairs( scores ) do
        love.graphics.setColor( v.is_player and player.bullet_color or WHITE )
        love.graphics.printf( v.text .. "  " .. v.score, SCR_W * .99 - limit, SCR_W * .01 + 20 * i, limit, "right" )
    end

--[[     love.graphics.setColor( WHITE )
    love.graphics.print( ( "ANGLE  %d" ):format( player.ang ), SCR_W * .01, SCR_H * .8 - 65 )]]
    
    --  > Health
    local health = math.floor( player.health / player.max_health * 100, 0 )
    love.graphics.setColor( health > 75 and { .2, 1, .2 } or health > 25 and { 1, 1, .2 } or { .75, .1, .1 } )
    love.graphics.print( ( "%s  %d%%" ):format( player.type:upper(), health ), SCR_W * .01, SCR_H * .8 - 45 )

    --  > Speed
    local speed = math.floor( player:get_speed() / player.max_speed * 100 )
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( ( "SPEED  %d%%" ):format( math.min( speed, 100 ) ), SCR_W * .01, SCR_H * .8 - 25 )

    --  > Kills
    love.graphics.print( ( "KILLS  %d" ):format( player.kills ), SCR_W * .01, SCR_H * .8 - 5 )

    --  > Guns status
    local count = {}
    for i, v in ipairs( player.guns ) do
        local ready = player.health > 0 and not v.on_death and v.cooldown >= v.max_cooldown - .05
        love.graphics.setColor( ready and { .2, 1, .2 } or ( v.on_death or player.health <= 0 ) and { .75, .1, .1 } or WHITE )
        
        count[v.type] = ( count[v.type] or 0 ) + 1
        love.graphics.print( ( "%s %d  %s" ):format( v.type:upper(), count[v.type], ready and "READY" or ( v.on_death or player.health <= 0 ) and "DEAD" or round( math.min( v.cooldown, v.max_cooldown ), 1 ) .. "s" ), SCR_W * .01, SCR_H * .8 + 20 * i )
    end

    Camera:push()
end