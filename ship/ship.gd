extends Node
class_name Ship

var instances = []
var instance_signal_counter = 0
signal ship_collided_with_asteroid
var screen_id
var exploding = false

onready var thruster_map = {
    "move_up" : $ForwardThruster,
    "move_left" : $RightThruster,
    "move_right" : $LeftThruster
}

func _ready():
    for child in get_children():
        var instance = child as ShipInstance
        if instance != null:
            instance.connect("instance_collided_with_asteroid", self, "_on_instance_collided_with_asteroid")
            instances.push_front(instance)

func _input(event):
    for action in thruster_map.keys():
        if event.is_action_pressed(action):
            thruster_map[action].play()
        if event.is_action_released(action):
            thruster_map[action].stop()
    if event.is_action_pressed("shoot_projectile"):
        $Gun.play()


func initialize(initial_position: Vector2, screenwrap_rule: EntityScreenWrapRule):
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
        $AsteroidCollision.play()
        $invincibility.start()
        for instance in instances:
            instance.become_invincible()

func _on_invincibility_timeout():
    if(exploding):
        queue_free()
    for instance in instances:
        instance.become_vincible()

func wire_collision_with_asteroid(node: Node, handler_func_name: String):
    connect("ship_collided_with_asteroid", node, handler_func_name)

func explode():
    for instance in instances:
        instance.explode()
    exploding = true

