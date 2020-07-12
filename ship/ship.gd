extends GameEntity
class_name Ship

var instance_signal_counter = 0
signal ship_collided_with_asteroid
var exploding = false

onready var thruster_map = {
    "move_up" : $ForwardThruster,
    "move_left" : $RightThruster,
    "move_right" : $LeftThruster
}

func _ready():
    connect("ship_collided_with_asteroid", self, "collided_with_asteroid")

func _on_instance_inside_play_area(instance):
    self.wrap_controller.reposition(instance, instances)

func initialize_instances():
    var instances = []
    for child in get_children():
        var instance = child as ShipInstance
        if instance != null:
            instance.connect("instance_collided_with_asteroid", self, "_on_instance_collided_with_asteroid")
            instances.push_front(instance)
    return instances

func center_instance():
    return $initial_center_instance

func _input(event):
    for action in thruster_map.keys():
        if event.is_action_pressed(action):
            thruster_map[action].play()
        if event.is_action_released(action):
            thruster_map[action].stop()
    if event.is_action_pressed("shoot_projectile"):
        $Gun.play()

func initialize(wrap_controller: InstanceWrapController, initial_position: Vector2) -> void:
    self.wrap_controller = wrap_controller
    self.wrap_controller.initialize_positions($initial_center_instance, instances, initial_position)

func _on_instance_collided_with_asteroid() -> void:
    instance_signal_counter += 1
    if(instance_signal_counter == instances.size()):
        emit_signal("ship_collided_with_asteroid")
        instance_signal_counter = 0

func collided_with_asteroid() -> void:
    if $invincibility.is_stopped():
        $AsteroidCollision.play()
        $invincibility.start()
        for instance in instances:
            instance.become_invincible()

func _on_invincibility_timeout() -> void:
    if(exploding):
        queue_free()
    for instance in instances:
        instance.become_vincible()

func wire_collision_with_asteroid(node: Node, handler_func_name: String) -> void:
    connect("ship_collided_with_asteroid", node, handler_func_name)

func explode() -> void:
    for instance in instances:
        instance.explode()
    exploding = true
