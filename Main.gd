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
    ships = generate_ships()
    entity_screen_wrap_rule = load("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
    entity_screen_wrap_rule.reposition_around(central_ship,ships)
    shipEdgePositionController = load("res://ShipEdgePositionController/ShipEdgePositionController.gd").new(edges,entity_screen_wrap_rule)
    add_child(shipEdgePositionController)

func generate_ships():
    var ships = []
    for i in range(ships_to_generate):
        var ship = shipScene.instance()
        add_child(ship)
        ships.push_front(ship)
    return ships




