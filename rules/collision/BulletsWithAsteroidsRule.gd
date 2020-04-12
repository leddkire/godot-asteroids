extends Node
class_name BulletsWithAsteroidsRule

func _ready():
    pass

func apply_rule(bullet, asteroid_screen_instance):
    asteroid_screen_instance.call_deferred("split")
    bullet.pulverize()
