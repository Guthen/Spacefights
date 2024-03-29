local path, types = "lua.power-ups", {}
for i, v in ipairs( love.filesystem.getDirectoryItems( path ) ) do
    types[#types + 1] = v
end

--  > Power Up
PowerUps, PowerUp = {}, class( GameObject )
PowerUp.x, PowerUp.y = 0, 0
PowerUp.w, PowerUp.h = 0, 0
PowerUp.size_factor = 3
PowerUp.ang = 0

PowerUp.color = WHITE
PowerUp.icon = image( "icons/wrench.png" )
PowerUp.image = image( "power-ups/repair.png" )
PowerUp.type = "repair"

PowerUp.sounds = {
    pickup = {
        "power-ups/pickup01.wav",
        "power-ups/pickup02.wav",
        "power-ups/pickup03.wav",
    }
}

PowerUp.respawn = true

function PowerUp:init( type, x, y )
    --  > Type
    self.type = type or self.type
    local obj = table_copy( require( path .. "." .. self.type ) )
    for k, v in pairs( obj ) do
        self[k] = v
    end

    --  > Position
    self.x = x or self.x
    self.y = y or self.y

    --  > Size
    self.w, self.h = self.image:getDimensions()
    self.w, self.h = self.w * self.size_factor, self.h * self.size_factor

    --  > List
    PowerUps[self.id] = self
    HUD:add_target( self, WHITE, function( powerup, player )
        return distance( powerup.x + powerup.w / 2, powerup.y + powerup.h / 2, player.x + player.w / 2, player.y + player.h / 2 ) / powerup.size_factor <= 500
    end )
end

function PowerUp:on_collide( ship )
    --  > override purpose
end

function PowerUp:can_ai_target( ship )
    --  > override purpose
    return true
end

function PowerUp:update( dt )
    --  > Collision with Ships
    for k, v in pairs( Ships ) do
        if v.health > 0 and collide( self.x, self.y, self.w, self.h, v.x, v.y, v.w, v.h ) then
            self:on_collide( v )
            self:destroy()
            Ship.emit( self, "pickup" )
            v.target = nil --  > reset target

            --  > Respawn
            if self.respawn then
                PowerUp( types[math.random( #types )], random_map_position() )
            end

            break
        end
    end

    --  > Rotate power-up
    self.ang = self.ang + dt
end

function PowerUp:draw()
    local img_h = self.image:getHeight()
    local scale = self.w / img_h

    love.graphics.setColor( self.color )
    love.graphics.draw( self.image, self.x + self.w / 2, self.y + self.h / 2, self.ang, scale, scale, img_h / 2, img_h / 2 )
end

function PowerUp:destroy()
    HUD:remove_target( self )
    PowerUps[self.id] = nil
    GameObject.destroy( self )
end