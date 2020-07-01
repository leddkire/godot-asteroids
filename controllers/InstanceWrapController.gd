extends Node
class_name InstanceWrapController

var instances = []
var screenwrap_rule

func _init(center_instance, instances: Array, initial_position: Vector2, screenwrap_rule: EntityScreenWrapRule):
    for instance in instances:
        instance.connect("inside_play_area", self, "_on_instance_inside_play_area")
        self.instances.push_front(instance)
    
    self.screenwrap_rule = screenwrap_rule
    _initialize_positions(center_instance, initial_position)

func _initialize_positions(center_instance, initial_position: Vector2):
    center_instance.set_new_position(initial_position)

    var surrounding_instances = instances.duplicate(true)
    surrounding_instances.erase(center_instance)
    screenwrap_rule.reposition_around(center_instance, surrounding_instances)

func _on_instance_inside_play_area(instance):
    var surrounding_instances = instances.duplicate(true)
    surrounding_instances.erase(instance)
    self.screenwrap_rule.reposition_around(instance, surrounding_instances)
    