Camera = {}
Camera.x, Camera.y = 0, 0

function Camera:centerat( x, y )
    self.x = x - love.graphics.getWidth() / 2
    self.y = y - love.graphics.getHeight() / 2
end

function Camera:push()
    love.graphics.push()

    love.graphics.translate( -self.x, -self.y )
end 

function Camera:pop()
    love.graphics.pop()
end