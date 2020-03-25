extends Node
class_name BulletsWithAsteroidsRule

func _ready():
    pass

func apply_rule(bullet, asteroid):
    if asteroid.can_be_split():
        asteroid.split()
    else:
        asteroid.pulverize()
    bullet.pulverize()