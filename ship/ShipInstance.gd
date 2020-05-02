extends KinematicBody2D
class_name ShipInstance

var current_velocity_vector : Vector2 = Vector2(0,0)
onready var shooting_angle : float = 0
var screen_id
var is_center_instance

var bullet_screen_id = 0

var invincibility_animation = "Invincibility"
var idle_animation = "Idle"

var ship_velocity_vector_class = preload("res://ship/ShipVelocityVector.gd")
var rotation_vector_class = preload("res://ship/ShipRotationVector.gd")

signal instance_collided_with_asteroid

onready var action_to_thruster = {
    "move_up" : $ForwardPropulsion,
    "move_left" : $RightPropulsion,
    "move_right" : $LeftPropulsion
}

func _ready():
    set_physics_process(true)
    add_to_group(GroupConstants.SHIP)
    add_to_group(GroupConstants.DRIFTS)

func set_new_position(pos: Vector2):
    self.position = pos

func become_invincible():
    $AnimationPlayer.play(self.invincibility_animation)
    get_collision_node().set_deferred("monitoring", false)

func become_vincible():
    $AnimationPlayer.play(self.idle_animation)
    get_collision_node().monitoring = true

func _input(input_event : InputEvent):
    if input_event.is_action_pressed("shoot_projectile"):
        var pellet_shooting_angle = Vector2(1,1).rotated(self.rotation).angle()
        var pellet = _spawn_pellet_projectile(_get_projectile_spawn_position(), pellet_shooting_angle)
        self.get_parent().add_child(pellet)

    for action in action_to_thruster.keys():
        if(input_event.is_action_pressed(action)):
            action_to_thruster[action].emitting = true
        if(input_event.is_action_released(action)):
            action_to_thruster[action].emitting = false

func _physics_process(delta):
    self.rotation += _calculate_rotation_direction_from_input(delta)
    self.current_velocity_vector = _calculate_forward_propulsion(delta)
    var infinite_inertia = true
    var collision = move_and_collide(self.current_velocity_vector, infinite_inertia)

func _calculate_rotation_direction_from_input(delta):
    return rotation_vector_class.new(
            Input.is_action_pressed("move_left"),
            Input.is_action_pressed("move_right"),
            delta
        ).calculate()

func _calculate_forward_propulsion(delta):
    return ship_velocity_vector_class.new(
            Input.is_action_pressed("move_up"),
            self.rotation,
            self.current_velocity_vector,
            delta
        ).calculate()

var pellet_scn = preload("res://projectiles/pellet/pellet.tscn")
func _spawn_pellet_projectile(spawn_position : Vector2, projectile_rotation : float):
    var pellet = pellet_scn.instance()
    pellet.position = spawn_position
    pellet.rotation = projectile_rotation
    pellet.screen_id = str(self.screen_id) + "_bullet_" + str(bullet_screen_id)
    EntityCensus.add_entity_to_census(pellet)
    self.bullet_screen_id += 1
    return pellet

func _get_projectile_spawn_position():
    return $ProjectileSpawn.global_position

func _on_Area2D_body_entered(body):
    if body is AsteroidScreenInstance:
        emit_signal("instance_collided_with_asteroid")

func get_collision_node():
    return $CollisionArea
