Camera = {}
Camera.x, Camera.y = 0, 0
Camera.shake_intensity = 0

function Camera:shake( intensity )
    self.shake_intensity = intensity
end

function Camera:centerat( x, y )
    self.x = x - love.graphics.getWidth() / 2
    self.y = y - love.graphics.getHeight() / 2
end

function Camera:update( dt )
    self.shake_intensity = lerp( dt * 2, self.shake_intensity, 0 )
end

function Camera:push()
    love.graphics.push()

    love.graphics.translate( -self.x, -self.y )
    if self.shake_intensity > 0 then
        love.graphics.translate( math.random( -1, 1 ) * self.shake_intensity, math.random( -1, 1 ) * self.shake_intensity )
    end
end 

function Camera:pop()
    love.graphics.pop()
end