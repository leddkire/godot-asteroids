 extends Node2D

var shipScene = preload("res://ship/ship.tscn")
const sides_and_corners_of_screen = 8

func _ready():
    var entity_screen_wrap_rule : EntityScreenWrapRule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    add_child(create_ship_position_controller(entity_screen_wrap_rule))
    spawn_ship(entity_screen_wrap_rule)
    spawn_asteroids(entity_screen_wrap_rule)

func create_ship_position_controller(wrap_rule: EntityScreenWrapRule):
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var screenWrapController = load("res://ScreenWrapController/ScreenWrapController.gd").new(edges,wrap_rule,EntityCensus)
    return screenWrapController


func spawn_ship(wrap_rule : EntityScreenWrapRule):
    var ships : Array = get_tree().get_nodes_in_group("ships")
    assert(ships.size() == 1)
    var central_ship = ships.front()
    central_ship.screen_id = EntityCensus.issue_new_id()
    EntityCensus.add_entity_to_census(central_ship)
    ships = generate_screen_wrap_objects(shipScene, sides_and_corners_of_screen, central_ship.screen_id)
    wrap_rule.reposition_around(central_ship,ships)


func spawn_asteroids(entity_screen_wrap_rule):
    var asteroid_scene = load("res://asteroids/Asteroid.tscn")
    var center_asteroid = asteroid_scene.instance()
    center_asteroid.position = Vector2(100,100) # Position should be random
    add_child(center_asteroid)
    center_asteroid.screen_id = EntityCensus.issue_new_id()
    EntityCensus.add_entity_to_census(center_asteroid)
    var surrounding_asteroids = generate_screen_wrap_objects(asteroid_scene, 8, center_asteroid.screen_id)
    entity_screen_wrap_rule.reposition_around(center_asteroid, surrounding_asteroids)

func generate_screen_wrap_objects(scene, amount_to_instance, screen_id):
    var objects = []
    for _i in amount_to_instance:
        var object = scene.instance()
        add_child(object)
        objects.push_front(object)
        object.screen_id = screen_id
        EntityCensus.add_entity_to_census(object)
    return objects


