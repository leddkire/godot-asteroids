class_name ShipVelocityVector

var current_velocity_vector : Vector2 = Vector2(0,0)
var thrust = 10
var friction : float = 0.99

var moving_forward = false
var delta = 0
var rotation = 0

func _init(moving_forward, rotation, vector, delta):
    self.moving_forward = moving_forward
    self.rotation = rotation
    self.current_velocity_vector = vector
    self.delta = delta

func calculate():
    return updated_velocity_vector() * self.friction

func updated_velocity_vector():
    return self.current_velocity_vector +  _calculate_forward_propulsion(self.rotation) * delta


func _calculate_forward_propulsion(current_rotation):
    if self.moving_forward:
        return _calculate_velocity(current_rotation)
    return Vector2(0,0)

func _calculate_velocity(current_rotation):
    return Vector2(sin(current_rotation),-cos(current_rotation)) * self.thrust
