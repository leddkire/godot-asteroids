 extends Node2D

var shipScene = preload("res://ship/ship.tscn")
const sides_and_corners_of_screen = 8
export (int) var asteroids_to_spawn = 5

func _ready():
    get_tree().paused = true

func start_game():
    var entity_screen_wrap_rule : EntityScreenWrapRule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    add_child(create_ship_position_controller(entity_screen_wrap_rule))
    var ship = spawn_ship()
    PlayerLives.initialize(ship)
    spawn_asteroids()
    get_tree().paused = false

func spawn_ship():
    var ship = load("res://ship/ship.tscn").instance()
    add_child(ship)
    ship.initialize(center_of_screen())
    return ship

func center_of_screen():
    return Vector2(250,250)

func spawn_asteroids():
    var asteroid_spawning_rule: AsteroidSpawningRule = load("res://rules/position/AsteroidSpawningRule.gd").new()
    for _i in asteroids_to_spawn:
        asteroid_spawning_rule.spawn_asteroid(self, Vector2(200,320), Vector2(160,320))

func create_ship_position_controller(wrap_rule: EntityScreenWrapRule):
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var screenWrapController = load("res://ScreenWrapController/ScreenWrapController.gd").new(edges,wrap_rule,EntityCensus)
    return screenWrapController