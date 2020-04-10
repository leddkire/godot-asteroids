extends Node
class_name BulletsWithAsteroidsRule

func _ready():
    pass

func apply_rule(bullet, asteroid):
    if asteroid.can_be_split():
        print_debug("Splitting asteroid: " + asteroid.name + " with size: " + asteroid.size)
        asteroid.call_deferred("split")
    else:
        asteroid.pulverize()
    bullet.pulverize()