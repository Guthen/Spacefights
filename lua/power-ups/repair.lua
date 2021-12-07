local powerup = {}
powerup.icon = image( "icons/wrench.png" )
powerup.image = image( "power-ups/repair.png" )

powerup.min_hp_percent = .25 --  > Percent of health given when ship has one or more weapons gone (cuz weapons are repaired)
powerup.max_hp_percent = .5 --  > Percent of health given when ship has all his weapons operational

function powerup:on_collide( ship )
    --  > Repair weapons if not operational
    local weapon_gone = false
    for i, v in ipairs( ship.guns ) do
        if v.on_death then
            v.on_death = false
            weapon_gone = true 
        end
    end

    --  > Restore a percent of health
    ship.health = math.min( ship.health + ship.max_health * ( weapon_gone and self.min_hp_percent or self.max_hp_percent ), ship.max_health )
end

function powerup:can_ai_target( ship )
    --  > AI will take this power-up if his health is half-reduced or one of his weapons are on_death
    return not ship.target and ship.health <= ship.max_health / 2 or some( ship.guns, function( gun ) return gun.on_death end )
end

return powerup