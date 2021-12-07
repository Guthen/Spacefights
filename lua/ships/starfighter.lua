local ship = {}

ship.health = 16

ship.turn_speed = 165
ship.max_speed = 10
ship.move_speed = 29
ship.brake_speed = 2

ship.icon = image( "icons/bomb.png" )
ship.image = image( "fighter_b.png" )
ship.bullet_color = GREEN

ship.guns = {
    { 
        x = 12, 
        y = 2,
        type = "primary",
        max_cooldown = .2,
    },
    { 
        x = 12, 
        y = 13,
        type = "primary",
        max_cooldown = .2, 
    },
    {
        x = 10,
        y = 7.5,
        type = "missile",
        max_cooldown = 5, 
    }
}

ship.thruster = {
    x = 2,
    y = 7,
}

return ship