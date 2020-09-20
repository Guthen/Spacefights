ShipAI = class( Ship )

ShipAI.target, ShipAI.target_time, ShipAI.target_max_time = nil, 0, 2

function ShipAI:findtarget()
    local target, min_dist = nil, math.huge
    for k, v in pairs( Ships ) do
        if not ( v == self ) and v.w and v.health > 0 then
            local dist = distance( v.x + v.w / 2, v.y + v.h / 2, self.x + self.w / 2, self.y + self.h / 2 )
            if dist < min_dist then
                min_dist = dist
                target = v
            end
        end
    end

    if target then
        self.target = target
    end
end

function ShipAI:update( dt )
    Ship.update( self, dt )

    --  > Dead, not big surprise
    if self.health <= 0 then return end

    --  > Target
    if self.target then
        --  > Switch target
        self.target_time = self.target_time + dt
        if self.target.health <= 0 or self.target_time >= self.target_max_time then
            self.target_time = 0
            self.target = nil
            return
        end

        --  > Follow
        self:lookat( dt, self.target.x, self.target.y )
        self:forward( dt, 1 )

        --  > Fire
        local ang = direction_angle( self.x + self.w / 2, self.y + self.h / 2, self.target.x + self.target.w / 2, self.target.y + self.target.h / 2 )
        if math.abs( self:getangdiff( ang ) ) < math.pi / 10 then 
            self:fire( dt, "primary" )
            self:fire( dt, "missile" )
        end 
    else  
        self:findtarget()
    end
end