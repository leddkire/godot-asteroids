class_name ShipRotationVector

var rotation_speed : float = 3
const LEFT_DIRECTION = -1
const RIGHT_DIRECTION  = 1
const NO_DIRECTION  = 0

var rotating_left = false
var rotating_right = false
var delta

func _init(rotating_left, rotating_right, delta):
    self.rotating_left = rotating_left
    self.rotating_right = rotating_right
    self.delta = delta

func calculate():
    return _calculate_rotation_direction() * self.rotation_speed * delta

func _calculate_rotation_direction():
    if rotating_right and rotating_left:
        return NO_DIRECTION
    if rotating_left:
        return LEFT_DIRECTION
    if rotating_right:
        return RIGHT_DIRECTION
    return NO_DIRECTION
