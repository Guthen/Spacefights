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

return turret