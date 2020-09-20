local ship = {}

ship.health = 7

ship.turn_speed = 175
ship.max_speed = 12
ship.move_speed = 30
ship.brake_speed = 3

ship.image = image( "fighter_a.png" )
ship.bullet_color = { 73 / 255, 170 / 255, 16 / 255 }

ship.guns = {
    { 
        x = 12, 
        y = 5,
        type = "primary",
        max_cooldown = .15, 
    },
    { 
        x = 12, 
        y = 10, 
        type = "primary",
        max_cooldown = .15, 
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