extends KinematicBody2D

onready var initial_velocity = 0
var current_velocity_vector : Vector2 = Vector2(0,0)
onready var thrust = 10
onready var current_rotation_direction : int = 0
onready var rotation_speed : float = 3
onready var friction : float = 0.99
onready var shooting_angle : float = 0
var screen_id
var is_center_instance
var ship_antenna

var bullet_screen_id = 0

const LEFT_DIRECTION = -1
const RIGHT_DIRECTION  = 1
const NO_DIRECTION  = 0

func _ready():
    set_physics_process(true)
    add_to_group(GroupConstants.SHIP)
    add_to_group(GroupConstants.DRIFTS)
    ship_antenna = ShipAntenna
    ship_antenna.connect("ship_collided_with_asteroid", self, "_on_ship_collided_with_asteroid")


func _input(input_event : InputEvent):
    if input_event.is_action_pressed("shoot_projectile"):
        var pellet_shooting_angle = Vector2(1,1).rotated(self.rotation).angle()
        var pellet = spawn_pellet_projectile(get_projectile_spawn_position(), pellet_shooting_angle)
        self.get_parent().add_child(pellet)

func _physics_process(delta):
    self.rotation += calculate_rotation_direction_from_input() * self.rotation_speed * delta
    self.current_velocity_vector = calculate_movement_vector_based_on_input(self.current_velocity_vector, self.rotation, delta)
    var infinite_inertia = true
    var collision = move_and_collide(self.current_velocity_vector, infinite_inertia)

func calculate_movement_vector_based_on_input(velocity_vector, current_rotation, delta):
    $ForwardPropulsion.emitting = false
    if Input.is_action_pressed("move_up") :
        velocity_vector += calculate_velocity(current_rotation) * delta
        $ForwardPropulsion.emitting = true
    return velocity_vector * self.friction

func calculate_velocity(current_rotation):
    return Vector2(sin(current_rotation),-cos(current_rotation)) * self.thrust

func calculate_rotation_direction_from_input():
    $LeftPropulsion.emitting = false
    $RightPropulsion.emitting = false
    if Input.is_action_pressed("move_left"):
        $RightPropulsion.emitting = true
        return LEFT_DIRECTION
    if Input.is_action_pressed("move_right") :
        $LeftPropulsion.emitting = true
        return RIGHT_DIRECTION
    return NO_DIRECTION

func physics_detection_is_disabled():
    return (self.collision_layer == 0) and (self.collision_mask == 1)

var pellet_scn = preload("res://projectiles/pellet/pellet.tscn")
func spawn_pellet_projectile(spawn_position : Vector2, projectile_rotation : float):
    var pellet = pellet_scn.instance()
    pellet.position = spawn_position
    pellet.rotation = projectile_rotation
    pellet.screen_id = str(self.screen_id) + "_bullet_" + str(bullet_screen_id)
    EntityCensus.add_entity_to_census(pellet)
    self.bullet_screen_id += 1
    return pellet

func get_projectile_spawn_position():
    return $ProjectileSpawn.global_position

func set_new_position(pos: Vector2):
    self.position = pos

func _on_Area2D_body_entered(body):
    if body is AsteroidScreenInstance:
        ship_antenna.ship_collided_with_asteroid()

func _on_ship_collided_with_asteroid():
    if $invincibility.is_stopped():
        $AnimationPlayer.play("Invincibility")
        $invincibility.start()
        $AsteroidCollision.set_deferred("monitoring", false)


func _on_invincibility_timeout():
    $AnimationPlayer.play("Idle")
    $AsteroidCollision.monitoring = true
