local ship = {}

ship.health = 16

ship.turn_speed = 150
ship.max_speed = 8
ship.move_speed = 29
ship.brake_speed = 2

ship.image = image( "fighter_b.png" )
ship.bullet_color = { 73 / 255, 170 / 255, 16 / 255 }

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