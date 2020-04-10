class_name AsteroidSpawningRule

var asteroid_scene
var entity_screen_wrap_rule

func _init(entity_screen_wrap_rule: EntityScreenWrapRule):
    self.entity_screen_wrap_rule = entity_screen_wrap_rule
    self.asteroid_scene = load("res://asteroids/Asteroid.tscn")

func _calculate_position() -> Vector2:
    var upper_y_limit = ProjectSettings.get_setting("display/window/size/height")
    var upper_x_limit = ProjectSettings.get_setting("display/window/size/width")
    return Vector2(randi() % upper_x_limit, randi() % upper_y_limit)

func spawn_asteroids() -> Array:
    var center_asteroid = asteroid_scene.instance()
    center_asteroid.position = _calculate_position()
    center_asteroid.size = "L"
    var surrounding_asteroids = generate_asteroid_screen_wrap_objects(8)
    entity_screen_wrap_rule.reposition_around(center_asteroid, surrounding_asteroids)
    surrounding_asteroids.append(center_asteroid)
    return surrounding_asteroids

func generate_asteroid_screen_wrap_objects(amount_to_instance):
    var objects = []
    for _i in range(amount_to_instance):
        var object = asteroid_scene.instance()
        object.size = "L"
        objects.append(object)
    return objects
