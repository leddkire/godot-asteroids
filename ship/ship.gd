extends KinematicBody2D

onready var initial_velocity = 0
var current_velocity_vector : Vector2 = Vector2(0,0)
onready var thrust = 10
onready var current_rotation_direction : int = 0
onready var rotation_speed : float = 2.5
onready var friction : float = 0.99
onready var shooting_angle : float = 0
var direction_vector : Vector2

signal entity_shooting

func _ready():

    set_physics_process(true)
    add_to_group(GroupConstants.SHIP)
    add_to_group(GroupConstants.DRIFTS)

func _input(input_event : InputEvent):
    if input_event.is_action("shoot_projectile"):
        var pellet = self.spawn_pellet_projectile(get_projectile_spawn_position(), direction_vector.angle())
        self.get_parent().add_child(pellet)

func _physics_process(delta):
    current_rotation_direction = calculate_rotation_direction_from_input()
    rotation += current_rotation_direction * rotation_speed * delta
    direction_vector = Vector2(1,1).rotated(rotation)
    var scoped_rotation = rotation
    if Input.is_action_pressed("move_up") :
        current_velocity_vector += Vector2(sin(scoped_rotation),-cos(scoped_rotation)) * thrust * delta
    current_velocity_vector = current_velocity_vector * friction
    move_and_collide(self.current_velocity_vector)


func calculate_rotation_direction_from_input():
    if Input.is_action_pressed("move_left"):
       return -1
    if Input.is_action_pressed("move_right") :
        return 1
    return 0

func calculate_velocity_from_input(current_velocity,acceleration,max_speed):
    if Input.is_action_pressed("move_up") :
        var velocity : float = current_velocity +  acceleration
        if(velocity > max_speed):
            velocity = max_speed
        return velocity
    else:
        return current_velocity

func _on_collision_area_entered(area):
    print("Entered: " + area.name)

func on_outer_edge_exited():
    self.disable_physics_detection()
    self.hide_visuals()

func disable_physics_detection():
    self.collision_layer = 0
    self.collision_mask = 1 #Only causes detection with the edge layer, which is bit 1

func hide_visuals():
    self.hide()

func on_edge_entered():
    if !is_showing_visuals() and physics_detection_is_disabled():
        self.show_visuals()

func is_showing_visuals():
    return self.is_visible()

func physics_detection_is_disabled():
    return (self.collision_layer == 0) and (self.collision_mask == 1)


func show_visuals():
    self.show()

var pellet_scn = preload("res://projectiles/pellet/pellet.tscn")
func spawn_pellet_projectile(spawn_position : Vector2, projectile_rotation : float):
    var pellet = pellet_scn.instance()
    pellet.position = spawn_position
    pellet.rotation = projectile_rotation
    return pellet

func get_projectile_spawn_position():
    return get_node("projectile_spawn").global_position
