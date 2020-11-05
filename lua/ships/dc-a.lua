local turret = {}
turret.controlable = false

turret.health = 10

turret.turn_speed = 200

turret.image = image( "dc-a.png" )
turret.bullet_color = GREEN

turret.guns = {
    { 
        x = 18, 
        y = 5,
        type = "primary",
        max_cooldown = .25,
    },
    { 
        x = 18, 
        y = 10,
        type = "primary",
        max_cooldown = .25,
    },
}

turret.sounds = {
    shoot = {
        "ships/shoot01a.wav",
        "ships/shoot02a.wav",
        "ships/shoot03a.wav",
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

return turret