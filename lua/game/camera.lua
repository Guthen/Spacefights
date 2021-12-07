Camera = {}
Camera.x, Camera.y = 0, 0
Camera.shake_intensity = 0

Camera.smooth_x, Camera.smooth_y = 0, 0
Camera.smooth_enabled, Camera.smooth_speed = true, 15

function Camera:shake( intensity )
    self.shake_intensity = intensity
end

function Camera:set_pos( x, y )
    self.smooth_x = x
    self.smooth_y = y

    --  don't move position here
    if not self.smooth_enabled then
        self.x = x
        self.y = y
    end
end

function Camera:get_screen_shake_translation( scale )
    scale = self.shake_intensity * ( scale or 1 )

    if self.shake_intensity == 0 then return 0, 0 end
    return math.random( -1, 1 ) * scale, math.random( -1, 1 ) * scale
end

function Camera:center_at( x, y )
    self:set_pos( x - SCR_W / 2, y - SCR_H / 2 )
end

function Camera:update( dt )
    if self.smooth_enabled then
        self.x, self.y = lerp( dt * self.smooth_speed, self.x, self.smooth_x ), lerp( dt * self.smooth_speed, self.y, self.smooth_y )
    end

    self.shake_intensity = lerp( dt * 2, self.shake_intensity, 0 )
end

function Camera:push()
    love.graphics.push()

    love.graphics.translate( -self.x, -self.y )
    love.graphics.translate( self:get_screen_shake_translation() )
end

function Camera:pop()
    love.graphics.pop()
end