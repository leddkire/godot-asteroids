 extends Node2D

var ship_scene = preload("res://ship/ship.tscn")
const sides_and_corners_of_screen = 8
export (int) var asteroids_to_spawn = 5

func _ready():
    get_tree().paused = true

func start_game():
    create_screen_wrap_controller()
    var ship = spawn_ship()
    PlayerLives.initialize(ship)
    ship.wire_collision_with_asteroid($MainCamera, "moderate_shake")
    spawn_asteroids()
    get_tree().paused = false

func spawn_ship():
    var ship = ship_scene.instance()
    add_child(ship)
    ship.initialize(center_of_screen())
    return ship

func center_of_screen():
    return Vector2(250,250)

func spawn_asteroids():
    var asteroid_spawning_rule: AsteroidSpawningRule = load("res://rules/position/AsteroidSpawningRule.gd").new()
    for _i in asteroids_to_spawn:
        asteroid_spawning_rule.spawn_asteroid(self, Vector2(200,320), Vector2(160,320))

func create_screen_wrap_controller():
    var wrap_rule : EntityScreenWrapRule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var screen_wrap_controller = load("res://ScreenWrapController/ScreenWrapController.gd").new(edges,wrap_rule,EntityCensus)
    add_child(screen_wrap_controller)
