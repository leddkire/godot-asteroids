extends KinematicBody2D

export (float) var speed = 2.5
var current_rotation_direction = 0
export (float) var rotation_speed = 1.5

func _ready():
    set_physics_process(true)
    add_to_group("ships")

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
