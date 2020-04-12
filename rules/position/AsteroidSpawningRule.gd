class_name AsteroidSpawningRule

var asteroid_scene

func _init():
    self.asteroid_scene = load("res://asteroids/Asteroid.tscn")

func _calculate_position() -> Vector2:
    var upper_y_limit = ProjectSettings.get_setting("display/window/size/height")
    var upper_x_limit = ProjectSettings.get_setting("display/window/size/width")
    return Vector2(randi() % upper_x_limit, randi() % upper_y_limit)

func spawn_asteroid(parent_node: Node) -> Asteroid:
    var asteroid = asteroid_scene.instance()
    parent_node.add_child(asteroid)
    asteroid.initialize(_calculate_position(),"L")
    return asteroid
