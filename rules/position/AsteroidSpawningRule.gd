class_name AsteroidSpawningRule

var factory
var upper_y_limit
var upper_x_limit

func _init():
    self.factory = load("res://asteroids/AsteroidFactory.gd").new()
    upper_y_limit = ProjectSettings.get_setting("display/window/size/height")
    upper_x_limit = ProjectSettings.get_setting("display/window/size/width")

func _calculate_position(width_to_avoid: Vector2, height_to_avoid: Vector2) -> Vector2:
    randomize()
    var x = randi() % upper_x_limit
    var x_outside_avoidance_range = x < width_to_avoid.x or x > width_to_avoid.y
    var y
    if(x_outside_avoidance_range):
        y = randi() % upper_y_limit
    else:
        y = _random_position_outside_range(height_to_avoid)
    return Vector2(x, y)

func _random_position_outside_range(height_to_avoid: Vector2):
        var cuadrant = randi() % 2
        var upper_cuadrant = (cuadrant == 0)
        if(upper_cuadrant):
            return randi() % int(height_to_avoid.x)
        else:
            return randi() % int(upper_y_limit - height_to_avoid.y) + height_to_avoid.y

func spawn_asteroid(parent_node: Node, width_to_avoid: Vector2, height_to_avoid: Vector2) -> Asteroid:
    return factory.create(parent_node, _calculate_position(width_to_avoid, height_to_avoid), "L")

