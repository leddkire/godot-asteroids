extends Node
class_name InstanceWrapController

var screenwrap_rule

func _init(screenwrap_rule: EntityScreenWrapRule):
    self.screenwrap_rule = screenwrap_rule

func initialize_positions(center_instance, instances, initial_position: Vector2):
    center_instance.set_new_position(initial_position)
    reposition(center_instance, instances)

func reposition(new_center_instance, instances):
    var surrounding_instances = instances.duplicate(true)
    surrounding_instances.erase(new_center_instance)
    self.screenwrap_rule.reposition_around(new_center_instance, surrounding_instances)
