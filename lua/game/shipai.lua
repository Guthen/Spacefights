ShipAI = class( Ship )

ShipAI.can_power_up = true
ShipAI.max_powerup_dist = 1000
ShipAI.target, ShipAI.target_time, ShipAI.target_max_time = nil, 0, 2

local names = {
    "ALPHAM",
    "BOLAREL",
    "CETA",
    "DARIOK",
    "EURK",
    "FALMYS",
    "GAKSTON",
    "HILARIUM",
    "ILYS",
    "JUKERNAUL",
}

function ShipAI:init( ... )
    --  > Get name
    if not self.name then
        local id = math.random( #names )
        self.name = names[id]
        --table.remove( names, id )
    end

    --  > Reset target
    self.target = nil
        
    Ship.init( self, ... )
end

function ShipAI:findtarget()
    local target = nil

    --  > Search power-up
    if self.can_power_up then
        local min_dist = math.huge
        for k, v in pairs( PowerUps ) do
            local dist = distance( self.x + self.w / 2, self.y + self.h / 2, v.x + v.w / 2, v.y + v.h / 2 )
            if v:canaitarget( self ) and dist < min_dist and dist / self.size_factor < self.max_powerup_dist then
                min_dist = dist
                target = v
            end
        end
    end

    --  > Search a ship target
    if not target then
        local min_dist = math.huge
        for k, v in pairs( Ships ) do
            if not ( v == self ) and v.w and v.health > 0 and not v.no_target then
                local dist = distance( v.x + v.w / 2, v.y + v.h / 2, self.x + self.w / 2, self.y + self.h / 2 )
                if dist < min_dist then
                    min_dist = dist
                    target = v
                end
            end
        end
    end

    --  > New target
    self.target = target
end

function ShipAI:update( dt )
    Ship.update( self, dt )

    --  > Dead, not big surprise
    if self.health <= 0 then return end

    --  > Target
    if self.target then
        --  > Follow
        self:lookat( dt, self.target.x, self.target.y )
        self:forward( dt, 1 )

        --  > Ship
        if class.instanceOf( self.target, ShipAI ) or class.instanceOf( self.target, Player ) then
            --  > Switch target
            self.target_time = self.target_time + dt
            if self.target.health <= 0 or self.target_time >= self.target_max_time then
                self.target_time = 0
                self:findtarget()
                return
            end

            --  > Fire
            local ang = direction_angle( self.x + self.w / 2, self.y + self.h / 2, self.target.x + self.target.w / 2, self.target.y + self.target.h / 2 )
            if math.abs( self:getangdiff( ang ) ) < math.pi / 10 then
                self:fire( dt, "primary" )
                self:fire( dt, "missile" )
            end
        end
    else
        self:findtarget()
    end
end