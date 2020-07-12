class_name GameEntity
extends Node


const INSTANCE_QTY = 9
var instances = []
var initial_center_instance
var scene
var wrap_controller

func _ready():
    self.instances = initialize_instances()
    self.initial_center_instance = center_instance()
    for instance in instances:
        instance.connect("inside_play_area", self, "_on_instance_inside_play_area")

# abstract template method
func initialize_instances() -> Array:
    return []

# abstract template method
func center_instance() -> Node:
    return null

func initialize(wrap_controller: InstanceWrapController, initial_position: Vector2):
    self.wrap_controller = wrap_controller
    wrap_controller.initialize_positions(initial_center_instance, instances, initial_position)

func _on_instance_inside_play_area(instance):
    wrap_controller.reposition(instance, instances)
