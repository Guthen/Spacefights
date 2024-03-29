local ship = {}

ship.health = 9

ship.turn_speed = 250
ship.max_speed = 10
ship.move_speed = 35
ship.brake_speed = 3

ship.icon = image( "icons/ship.png" )
ship.image = image( "keytehr.png" )
ship.bullet_color = ORANGE

ship.guns = {
    { 
        x = 14, 
        y = 7.5,
        type = "primary",
        max_cooldown = .125,
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
}

return ship