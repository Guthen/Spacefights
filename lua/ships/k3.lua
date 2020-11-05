local turret = {}
turret.controlable = false

turret.health = 12

turret.turn_speed = 175

turret.image = image( "k3.png" )
turret.bullet_color = ORANGE

turret.guns = {
    { 
        x = 20, 
        y = 7.5,
        type = "missile",
        max_cooldown = 1,
    },
}

turret.sounds = {
    shoot = {
        "ships/shoot01c.wav",
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