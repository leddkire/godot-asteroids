extends Node

var lives = 5

func _ready():
    pass

func initialize(ship: Node):
    ship.wire_collision_with_asteroid(self, "_on_ship_collided_with_asteroid")


func _on_ship_collided_with_asteroid():
    lives -= 1
    #print_debug("Lost a life. Left: " + str(lives))
    if(lives==0):
        #print_debug("Player has died")
        EndGameRule.end_game()

func reset():
    self.lives = 3
