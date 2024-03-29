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
        "turrets/shoot01.wav",
    },
}

return turret