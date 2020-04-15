class_name AsteroidSpawningRule

var asteroid_scene
var factory

func _init():
    self.asteroid_scene = load("res://asteroids/Asteroid.tscn")
    self.factory = load("res://asteroids/AsteroidFactory.gd").new()

func _calculate_position(width_to_avoid: Vector2, height_to_avoid: Vector2) -> Vector2:
    randomize()
    var upper_y_limit = ProjectSettings.get_setting("display/window/size/height")
    var upper_x_limit = ProjectSettings.get_setting("display/window/size/width")
    var x_position = randi() % upper_x_limit
    var y_position
    if(x_position < width_to_avoid.x or x_position > width_to_avoid.y):
        y_position = randi() % upper_y_limit
    else:
        var cuadrant = randi() % 2
        if(cuadrant == 0):
            y_position = randi() % int(height_to_avoid.x)
        else:
            y_position = randi() % int(upper_y_limit - height_to_avoid.y) + height_to_avoid.y
    return Vector2(x_position, y_position)

func spawn_asteroid(parent_node: Node, width_to_avoid: Vector2, height_to_avoid: Vector2) -> Asteroid:
    return factory.create(parent_node, _calculate_position(width_to_avoid, height_to_avoid), "L")

