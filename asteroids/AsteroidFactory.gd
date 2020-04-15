class_name AsteroidFactory

var scene

func _init():
    self.scene = load("res://asteroids/Asteroid.tscn")

func create(parent_node: Node, position: Vector2, size: String):
    var new_asteroid = scene.instance()
    new_asteroid.connect("asteroid_destroyed", EndGameRule, "_on_asteroid_destroyed")
    parent_node.add_child(new_asteroid)
    new_asteroid.initialize(position, size)
    return new_asteroid
