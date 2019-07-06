extends Node
class_name ShipEdgePositionController

var entity : Node2D
var duplicate_entity : Node2D
var edges

var entity_queue = []
var entity_queue_size = 3
var orientation_of_entity_that_entered

var lock_spawn = false


func _ready():
    self.set_name("ShipEdgePositionController")

func _init(entity,edges):
    self.entity = entity
    self.edges = edges
    for i in range(entity_queue_size):
        var entity_duplicate : KinematicBody2D = entity.duplicate()
        entity_queue.push_front(entity_duplicate)
    for edge in edges:
        edge.connect("edge_entered",self,"_on_edge_entered")
        edge.connect("edge_exited",self,"_on_edge_exited")



func _on_edge_entered(orientation : int, body : Object):
    if !lock_spawn:
        var orientation_str = Orientation.to_name(orientation)
        print_debug(orientation_str + " edge entered at: " + str(body.position))
        lock_spawn = true
        orientation_of_entity_that_entered = orientation
        var position_on_other_edge = determine_edge_position(body.position, orientation)
        print_debug("position for entity on other edge: " + str(position_on_other_edge))
        duplicate_entity = entity_queue.pop_front()
        duplicate_entity.position = position_on_other_edge
        duplicate_entity.rotation = entity.rotation
        entity.get_parent().add_child(duplicate_entity)

func _on_edge_exited(orientation : int, body : Object, side_exited: int):
    if (orientation == orientation_of_entity_that_entered) && lock_spawn:
        print_debug(Orientation.to_name(orientation) + " edge exited at: " + str(body.position))
        print_debug("Side exited: " + Edge_Side.to_name(side_exited))
        var entity_to_remove
        var entity_that_will_become_original
        if side_exited == Edge_Side.INNER:
            entity_to_remove = duplicate_entity
            entity_that_will_become_original = entity
        elif side_exited == Edge_Side.OUTER:
            entity_to_remove = entity
            entity_that_will_become_original = duplicate_entity
        entity_to_remove.get_parent().remove_child(entity_to_remove)
        entity_queue.push_back(entity_to_remove)
        entity = entity_that_will_become_original
        duplicate_entity = null
        lock_spawn = false

func determine_edge_position(body_position : Vector2, orientation):
    match orientation:
        Orientation.North:
            return Vector2(body_position.x,body_position.y + ProjectSettings.get_setting("display/window/size/height"))
        Orientation.South:
            return Vector2(body_position.x,body_position.y - ProjectSettings.get_setting("display/window/size/height"))
        Orientation.East:
            return Vector2(body_position.x - ProjectSettings.get_setting("display/window/size/width"),body_position.y)
        Orientation.West:
            return Vector2(body_position.x + ProjectSettings.get_setting("display/window/size/width"),body_position.y)