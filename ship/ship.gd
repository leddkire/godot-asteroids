extends KinematicBody2D

export (float) var speed = 2.5
var current_rotation_direction = 0
export (float) var rotation_speed = 1.5

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
    direction_vector = Vector2(1, 1).rotated(rotation)
    var velocity_vector = calculate_velocity_from_input().rotated(rotation)
    move_and_collide(velocity_vector)

func calculate_rotation_direction_from_input():
    if Input.is_action_pressed("move_left"):
       return -1
    if Input.is_action_pressed("move_right") :
        return 1
    return 0

func calculate_velocity_from_input():
    var velocity = Vector2()
    if Input.is_action_pressed("move_up") :
        velocity.y = -1
    if Input.is_action_pressed("move_down") :
        velocity.y = 1
    return velocity.normalized() * speed

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
