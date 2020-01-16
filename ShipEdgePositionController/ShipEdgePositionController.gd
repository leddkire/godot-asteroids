extends Node
class_name ShipEdgePositionController

var edges

func _ready():
    self.set_name("ShipEdgePositionController")

func _init(edges):
    self.edges = edges
    for edge in edges:
        edge.connect("edge_entered",self,"_on_edge_entered")
        edge.connect("edge_exited",self,"_on_edge_exited")

func _on_edge_entered(orientation : int, body : PhysicsBody2D):
    if body.is_in_group(GroupConstants.DRIFTS):
        body.on_edge_entered()

func _on_edge_exited(orientation : int, body : PhysicsBody2D, side_exited: int):
    if body.is_in_group(GroupConstants.DRIFTS):
        if side_exited == Edge_Side.OUTER:
            body.on_outer_edge_exited()
        if side_exited == Edge_Side.INNER:
            var ships : Array = self.get_tree().get_nodes_in_group(GroupConstants.SHIP)
            ships.erase(body)
            _reposition_ships_around(body,ships)

func _reposition_ships_around(object,objects):
    var screen_width = ProjectSettings.get_setting("display/window/size/width")
    var screen_height = ProjectSettings.get_setting("display/window/size/height")
    assert(objects.size() == 4)
    var object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x + screen_width
    object_without_position.position.y = object.position.y

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x - screen_width
    object_without_position.position.y = object.position.y

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x
    object_without_position.position.y = object.position.y + screen_height

    object_without_position = objects.pop_front()
    object_without_position.position.x = object.position.x
    object_without_position.position.y = object.position.y - screen_height