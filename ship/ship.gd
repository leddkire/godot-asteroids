extends KinematicBody2D

export (float) var speed = 2.5
var current_rotation_direction = 0
export (float) var rotation_speed = 1.5

onready var collision_layer_backup = self.collision_layer
onready var collision_mask_backup = self.collision_mask

func _ready():
    set_physics_process(true)
    add_to_group(GroupConstants.SHIP)
    add_to_group(GroupConstants.DRIFTS)

func _physics_process(delta):
    current_rotation_direction = calculate_rotation_direction_from_input()
    rotation += current_rotation_direction * rotation_speed * delta
    move_and_collide(calculate_velocity_from_input().rotated(rotation))

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
        self.enable_physics_detection()
        self.show_visuals()

func is_showing_visuals():
    return self.is_visible()

func physics_detection_is_disabled():
    return (self.collision_layer == 0) and (self.collision_mask == 1)

func enable_physics_detection():
    self.collision_layer = self.collision_layer_backup
    self.collision_mask = self.collision_mask_backup

func show_visuals():
    self.show()