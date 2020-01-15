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