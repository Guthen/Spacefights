local ship = {}

ship.health = 13

ship.turn_speed = 185
ship.max_speed = 11
ship.move_speed = 28
ship.brake_speed = 3

ship.icon = image( "icons/arrow.png" )
ship.image = image( "larysm.png" )
ship.bullet_color = GREEN

ship.guns = {
    { 
        x = 10,
        y = 3,
        type = "primary",
        max_cooldown = .15, 
    },
    { 
        x = 10, 
        y = 12, 
        type = "primary",
        max_cooldown = .15, 
    },
}

ship.thruster = {
    x = 2,
    y = 7,
}

return ship