extends Node

var instances = []
onready var screenwrap_rule = preload("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()
var instance_signal_counter = 0
signal ship_collided_with_asteroid
var screen_id

func _ready():
    for child in get_children():
        var instance = child as ShipInstance
        if instance != null:
            instance.connect("instance_collided_with_asteroid", self, "_on_instance_collided_with_asteroid")
            instances.push_front(instance)

func initialize(initial_position: Vector2):
    self.screen_id = EntityCensus.issue_new_id()

    for instance in instances:
        instance.screen_id = self.screen_id
        EntityCensus.add_entity_to_census(instance)

    $initial_center_instance.set_new_position(initial_position)

    var surrounding_instances = instances.duplicate(true)
    surrounding_instances.erase($initial_center_instance)
    screenwrap_rule.reposition_around($initial_center_instance, surrounding_instances)

func _on_instance_collided_with_asteroid():
    instance_signal_counter += 1
    if(instance_signal_counter == instances.size()):
        collided_with_asteroid()
        instance_signal_counter = 0

func collided_with_asteroid():
    emit_signal("ship_collided_with_asteroid")
    if $invincibility.is_stopped():
        $invincibility.start()
        for instance in instances:
            instance.become_invincible()

func _on_invincibility_timeout():
    for instance in instances:
        instance.become_vincible()

func wire_collision_with_asteroid(node: Node, handler_func_name: String):
    connect("ship_collided_with_asteroid", node, handler_func_name)
