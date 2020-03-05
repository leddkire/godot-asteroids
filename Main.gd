 extends Node2D

var shipEdgePositionController
var shipScene = preload("res://ship/ship.tscn")
const ships_to_generate = 8
var entity_screen_wrap_rule : EntityScreenWrapRule

func _ready():
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var ships : Array = get_tree().get_nodes_in_group("ships")
    assert(ships.size() == 1)
    var central_ship = ships.front()
    ships = generate_screen_wrap_objects(shipScene, ships_to_generate)
    entity_screen_wrap_rule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    entity_screen_wrap_rule.reposition_around(central_ship,ships)
    shipEdgePositionController = load("res://ShipEdgePositionController/ShipEdgePositionController.gd").new(edges,entity_screen_wrap_rule)
    add_child(shipEdgePositionController)
    spawn_asteroids(entity_screen_wrap_rule)

func spawn_asteroids(entity_screen_wrap_rule):
    var asteroid_scene = load("res://asteroids/Asteroid.tscn")
    var center_asteroid = asteroid_scene.instance()
    center_asteroid.position = Vector2(100,100) # Position should be random
    add_child(center_asteroid)
    var surrounding_asteroids = generate_screen_wrap_objects(asteroid_scene, 8)
    entity_screen_wrap_rule.reposition_around(center_asteroid, surrounding_asteroids)

func generate_screen_wrap_objects(scene, amount_to_instance):
    var objects = []
    for _i in amount_to_instance:
        var object = scene.instance()
        add_child(object)
        objects.push_front(object)
    return objects


