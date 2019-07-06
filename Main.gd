 extends Node2D

var shipEdgePositionController : ShipEdgePositionController

func _ready():
    var edges : Array = get_tree().get_nodes_in_group("edges")
    assert(edges.size() == 4)
    var ships : Array = get_tree().get_nodes_in_group("ships")
    assert(ships.size() == 1)
    var ship = ships.front()
    shipEdgePositionController = load("res://ShipEdgePositionController/ShipEdgePositionController.gd").new(ship,edges)
    add_child(shipEdgePositionController)


