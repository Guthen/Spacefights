local ship = {}

ship.health = 16

ship.turn_speed = 175
ship.max_speed = 10
ship.move_speed = 31
ship.brake_speed = 1.6

ship.icon = image( "icons/arrow.png" )
ship.image = image( "steylky.png" )
ship.bullet_color = ORANGE

ship.guns = {
    { 
        x = 13, 
        y = 3,
        type = "primary",
        max_cooldown = .15,
    },
    {
        x = 13,
        y = 12,
        type = "primary",
        max_cooldown = .15,
    },
}

ship.thruster = {
    x = 3,
    y = 7,
}

ship.sounds = 
{
    shoot = {
        "ships/shoot01b.wav",
        "ships/shoot02b.wav",
        "ships/shoot03b.wav",
    },
}

return ship