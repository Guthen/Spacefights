local ship = {}

ship.health = 15

ship.turn_speed = 195
ship.max_speed = 8
ship.move_speed = 30
ship.brake_speed = 2.5

ship.icon = image( "icons/bomb.png" )
ship.image = image( "tyker.png" )
ship.bullet_color = ORANGE

ship.guns = {
    { 
        x = 15, 
        y = 7.5,
        type = "primary",
        max_cooldown = .25,
    },
    { 
        x = 13, 
        y = 3,
        type = "missile",
        max_cooldown = 6,
    },
    { 
        x = 13, 
        y = 12,
        type = "missile",
        max_cooldown = 6,
    },
}

ship.thruster = {
    x = 0,
    y = 7,
}

ship.sounds = {
    shoot = {
        "ships/shoot01b.wav",
        "ships/shoot02b.wav",
        "ships/shoot03b.wav",
    },
}

return ship