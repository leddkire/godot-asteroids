extends Camera2D

export var shake_decay_percentage: float = 0.8  # [0, 1]
export var max_horizontal_shake_offset = 100
export var max_vertical_shake_offset = 75
onready var shake_offsets = Vector2(self.max_horizontal_shake_offset, self.max_vertical_shake_offset)

export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

var shake_strength = 0.0
var shake_power: int = 2  # [2, 3].

func _ready():
    randomize()

func slight_shake():
    strengthen_shake(0.2)

func moderate_shake():
    strengthen_shake(0.35)

func strengthen_shake(amount):
    if(amount > 1 or amount < 0):
        printerr("Shake amount outside of allowed range [0,1]:" + str(amount))
        return
    shake_strength = min(shake_strength + amount, 1.0)

func _process(delta):
    if(shake_strength):
        shake_strength = max(shake_strength - shake_decay_percentage * delta, 0)
        shake()

func shake():
    var amount = pow(shake_strength, shake_power)
    rotation = max_roll * amount * rand_range(-1, 1)
    offset.x = shake_offsets.x * amount * rand_range(-1, 1)
    offset.y = shake_offsets.y * amount * rand_range(-1, 1)
