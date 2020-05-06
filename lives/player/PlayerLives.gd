extends Node

var lives = 5
var hud

func _ready():
    pass

func initialize(ship: Node, hud):
    ship.wire_collision_with_asteroid(self, "_on_ship_collided_with_asteroid")
    self.hud = hud
    self.hud.set_player_lives(lives)


func _on_ship_collided_with_asteroid():
    lives -= 1
    hud.set_player_lives(lives)
    #print_debug("Lost a life. Left: " + str(lives))
    if(lives==0):
        #print_debug("Player has died")
        EndGameRule.end_game()

func reset():
    self.lives = 3
