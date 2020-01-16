 extends Node2D

var shipEdgePositionController : ShipEdgePositionController
var shipScene = preload("res://ship/ship.tscn")

func _ready():
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var ships : Array = get_tree().get_nodes_in_group("ships")
    assert(ships.size() == 1)
    var central_ship = ships.front()
    ships = generate_ships()
    position_around(central_ship,ships)
    shipEdgePositionController = load("res://ShipEdgePositionController/ShipEdgePositionController.gd").new(edges)
    add_child(shipEdgePositionController)

func generate_ships():
    var ships = []
    for i in range(4):
        var ship = shipScene.instance()
        ships.push_front(ship)
    return ships

func position_around(object,objects):
    var screen_width = ProjectSettings.get_setting("display/window/size/width")
    var screen_height = ProjectSettings.get_setting("display/window/size/height")
    assert(objects.size() == 4)
    var object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x + screen_width
    object_without_position.position.y = object.position.y
    add_child(object_without_position)

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x - screen_width
    object_without_position.position.y = object.position.y
    add_child(object_without_position)

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x
    object_without_position.position.y = object.position.y + screen_height
    add_child(object_without_position)

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x
    object_without_position.position.y = object.position.y - screen_height
    add_child(object_without_position)



