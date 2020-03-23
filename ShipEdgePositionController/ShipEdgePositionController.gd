extends Node
class_name ShipEdgePositionController

var edges
var entity_screen_wrap_rule : EntityScreenWrapRule
var entity_screen_census: EntityCensus

func _ready():
    self.set_name("ShipEdgePositionController")

func _init(edges, entity_screen_wrap_rule, entity_screen_census: EntityCensus):
    self.edges = edges
    self.entity_screen_wrap_rule = entity_screen_wrap_rule
    self.entity_screen_census = entity_screen_census
    for edge in edges:
        edge.connect("edge_exited",self,"_on_edge_exited")

func _on_edge_exited(orientation : int, body : PhysicsBody2D, side_exited: int):
    if body.is_in_group(GroupConstants.DRIFTS):
        if (side_exited == Edge_Side.INNER and is_inside_screen(body)) :
            var entities = entity_screen_census.get_in_census(body.screen_id)
            entities.erase(body)
            entity_screen_wrap_rule.reposition_around(body,entities)

func is_inside_screen(body):
    var screen_width = ProjectSettings.get_setting("display/window/size/width")
    var screen_height = ProjectSettings.get_setting("display/window/size/height")
    return body.position.x < screen_width and body.position.x > 0 and body.position.y < screen_height and body.position.y > 0
