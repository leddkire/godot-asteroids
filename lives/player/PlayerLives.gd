extends Node

var lives = 3

func _ready():
    ShipAntenna.connect("ship_collided_with_asteroid", self, "_on_ship_collided_with_asteroid")

func _on_ship_collided_with_asteroid():
    lives -= 1
    print_debug("Lost a life. Left: " + str(lives))
    if(lives==0):
        print_debug("Player has died")
