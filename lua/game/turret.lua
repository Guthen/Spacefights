Turret = class( ShipAI )

Turret.health = 5

Turret.turn_speed = 150
Turret.max_speed = 0
Turret.move_speed = 0
Turret.brake_speed = 0

Turret.ang = 0

Turret.icon = image( "icons/turret.png" )
Turret.image = image( "k3.png" )
Turret.color = WHITE
Turret.bullet_color = Ship.color

Turret.shader, Turret.shader_color = nil, Turret.color
Turret.hit_anim = 1

Turret.has_thruster = false
Turret.can_power_up = false

Turret.type = "k3"

function Turret:init( x, y, type )
    Ship.init( self, x, y, type or self.type )

    self.name = self.type:upper()
end