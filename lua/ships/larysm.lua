local ship = {}

ship.health = 13

ship.turn_speed = 185
ship.max_speed = 11
ship.move_speed = 28
ship.brake_speed = 3

ship.icon = image( "icons/ship.png" )
ship.image = image( "larysm.png" )
ship.bullet_color = { 73 / 255, 170 / 255, 16 / 255 }

ship.guns = {
    { 
        x = 10,
        y = 3,
        type = "primary",
        max_cooldown = .2, 
    },
    { 
        x = 10, 
        y = 12, 
        type = "primary",
        max_cooldown = .2, 
    },
}

ship.thruster = {
    x = 2,
    y = 7,
}

ship.sounds = {
    shoot = {
        "ships/shoot01.wav",
        "ships/shoot02.wav",
        "ships/shoot03.wav",
    },
    hit = {
        "ships/hit01.wav",
        "ships/hit02.wav",
        "ships/hit03.wav",
    },
    destroy = {
        "ships/destroy01.wav",
        "ships/destroy02.wav",
        "ships/destroy03.wav",
    },
}

return ship