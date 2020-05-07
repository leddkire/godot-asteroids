extends Node

var start_of_game: PackedScene

func _ready():
    start_of_game = load("res://StartOfGame.tscn")

func _on_asteroid_destroyed():
    #print("A small asteroid was destroyed")
    if(only_the_last_destroyed_asteroid_left()):
        print("End of the level.")
        end_game()

func only_the_last_destroyed_asteroid_left():
    var asteroids_left = EntityCensus.asteroids()
    #print("Asteroids left: " + str(asteroids_left))
    return asteroids_left == 1

func end_game():
        yield(get_tree().create_timer(3.0), "timeout")
        EntityCensus.clear()
        PlayerLives.reset()
        self.get_tree().change_scene_to(start_of_game)
