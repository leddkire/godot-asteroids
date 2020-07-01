 extends Node2D

var ship_scene = preload("res://ship/ship.tscn")
export (Vector2) var play_area: Vector2 = Vector2(int(500),int(448))
const sides_and_corners_of_screen = 8
export (int) var asteroids_to_spawn = 5
export (int) var lives = 5

func _ready():
    play_area = play_area.round()
    $HUD.hide()
    get_tree().paused = true

func start_game():
    $HUD.show()
    var wrap_rule : EntityScreenWrapRule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new(play_area.x, play_area.y)
    create_screen_wrap_controller(wrap_rule)
    var ship = spawn_ship(wrap_rule)
    PlayerLives.initialize(lives, ship, $HUD)
    ship.wire_collision_with_asteroid($MainCamera, "moderate_shake")
    spawn_asteroids(wrap_rule)
    get_tree().paused = false

func spawn_ship(wrap_rule: EntityScreenWrapRule):
    var ship = ship_scene.instance()
    add_child(ship)
    ship.initialize(center_of_screen(), wrap_rule)
    PlayerLives.connect("player_died",ship,"explode")
    return ship

func center_of_screen():
    return Vector2(250,250)

func spawn_asteroids(wrap_rule: EntityScreenWrapRule):
    var asteroid_factory: AsteroidFactory = AsteroidFactory.new(wrap_rule)
    var asteroid_spawning_rule: AsteroidSpawningRule = AsteroidSpawningRule.new(asteroid_factory, play_area.x, play_area.y)
    for _i in asteroids_to_spawn:
        asteroid_spawning_rule.spawn_asteroid(self, Vector2(200,320), Vector2(160,320))

func create_screen_wrap_controller(wrap_rule: EntityScreenWrapRule):
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var instance_edge_sensor = InstanceEdgeSensor.new(edges,play_area.x, play_area.y)
    add_child(instance_edge_sensor)
