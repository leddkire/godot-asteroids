extends Node
class_name ScreenWrapController

var edges
var entity_screen_wrap_rule : EntityScreenWrapRule
var entity_screen_census: EntityCensus
var play_area_width = ProjectSettings.get_setting("display/window/size/width")
var play_area_height = ProjectSettings.get_setting("display/window/size/height")

onready var constants = preload("res://screen/ScreenWrapConstants.gd")

func _ready():
    self.set_name("ScreenWrapController")

func _init(edges, entity_screen_wrap_rule, entity_screen_census: EntityCensus):
    play_area_width = ProjectSettings.get_setting("display/window/size/width")
    play_area_height = ProjectSettings.get_setting("display/window/size/height")
    self.edges = edges
    self.entity_screen_wrap_rule = entity_screen_wrap_rule
    self.entity_screen_census = entity_screen_census
    for edge in edges:
        edge.connect("edge_exited",self,"_on_edge_exited")

func _on_edge_exited(orientation : int, body, side_exited: int):
    if is_valid_driftable_body_that_exited_inner_edge(body, side_exited):
        var entities = entity_screen_census.get_in_census(body.screen_id)
        assert(entities.size() == constants.INSTANCES_ON_SCREEN)
        if(entities != null and !entities.empty()):
            entities.erase(body)
            entity_screen_wrap_rule.call_deferred("reposition_around", body, entities)

func is_valid_driftable_body_that_exited_inner_edge(body, side_exited):
    return is_instance_valid(body) and body.is_in_group(GroupConstants.DRIFTS) and exited_inner_edge(body, side_exited)

func exited_inner_edge(body, side_exited):
    return side_exited == Edge_Side.INNER and is_inside_screen(body)

func is_inside_screen(body):
    return body.position.x < play_area_width and body.position.x > 0 and body.position.y < play_area_height and body.position.y > 0
