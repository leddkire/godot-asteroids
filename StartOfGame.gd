 extends Node2D

var shipScene = preload("res://ship/ship.tscn")
const sides_and_corners_of_screen = 8
export (int) var asteroids_to_spawn = 5

func _ready():
    var entity_screen_wrap_rule : EntityScreenWrapRule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    add_child(create_ship_position_controller(entity_screen_wrap_rule))
    spawn_ship(entity_screen_wrap_rule)
    spawn_asteroids()

func spawn_asteroids():
    var asteroid_spawning_rule = load("res://rules/position/AsteroidSpawningRule.gd").new()
    for _i in asteroids_to_spawn:
        asteroid_spawning_rule.spawn_asteroid(self)

func create_ship_position_controller(wrap_rule: EntityScreenWrapRule):
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var screenWrapController = load("res://ScreenWrapController/ScreenWrapController.gd").new(edges,wrap_rule,EntityCensus)
    return screenWrapController

func spawn_ship(wrap_rule : EntityScreenWrapRule):
    var central_ship = get_existing_ship()
    add_to_census(central_ship)
    var ships = generate_screen_wrap_objects(shipScene, sides_and_corners_of_screen, central_ship.screen_id)
    wrap_rule.reposition_around(central_ship,ships)

func get_existing_ship():
    var ships : Array = get_tree().get_nodes_in_group("ships")
    assert(ships.size() == 1)
    return ships.front()

func add_to_census(entity):
    entity.screen_id = EntityCensus.issue_new_id()
    EntityCensus.add_entity_to_census(entity)

func generate_screen_wrap_objects(scene, amount_to_instance, screen_id):
    var objects = []
    for _i in amount_to_instance:
        var object = scene.instance()
        add_child(object)
        objects.push_front(object)
        object.screen_id = screen_id
        EntityCensus.add_entity_to_census(object)
    return objects


