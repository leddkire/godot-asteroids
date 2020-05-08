extends Node
class_name ScreenWrapController

var edges
var play_area_width = ProjectSettings.get_setting("display/window/size/width")
var play_area_height = ProjectSettings.get_setting("display/window/size/height")

onready var constants = preload("res://screen/ScreenWrapConstants.gd")

func _ready():
    self.set_name("ScreenWrapController")

func _init(edges, play_area_width: int, play_area_height: int):
    self.play_area_width = play_area_width
    self.play_area_height = play_area_height
    self.edges = edges
    for edge in edges:
        edge.connect("edge_exited",self,"_on_edge_exited")

func _on_edge_exited(orientation : int, body, side_exited: int):
    if is_valid_driftable_body_that_exited_inner_edge(body, side_exited):
        body.inside_play_area()


func is_valid_driftable_body_that_exited_inner_edge(body, side_exited):
    return is_instance_valid(body) and body.is_in_group(GroupConstants.DRIFTS) and exited_inner_edge(body, side_exited)

func exited_inner_edge(body, side_exited):
    return side_exited == Edge_Side.INNER and is_inside_screen(body)

func is_inside_screen(body):
    return body.position.x < play_area_width and body.position.x > 0 and body.position.y < play_area_height and body.position.y > 0
