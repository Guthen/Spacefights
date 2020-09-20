local ship = {}

ship.health = 9

ship.turn_speed = 250
ship.max_speed = 10
ship.move_speed = 35
ship.brake_speed = 3

ship.image = image( "keytehr.png" )
ship.bullet_color = { 255 / 255, 121 / 255, 48 / 255 }

ship.guns = {
    { 
        x = 14, 
        y = 7.5,
        type = "primary",
        max_cooldown = .1,
    },
}

ship.thruster = {
    x = 2,
    y = 7,
}

ship.sounds = {
    shoot = {
        "ships/shoot01b.wav",
        "ships/shoot02b.wav",
        "ships/shoot03b.wav",
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