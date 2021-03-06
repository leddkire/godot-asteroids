extends Area2D

export var speed : int = 10
var screen_id
var is_center_instance

onready var bullet_with_asteroids_rule : BulletsWithAsteroidsRule = load("res://rules/collision/BulletsWithAsteroidsRule.gd").new()

func _ready():
    set_physics_process(true)
    add_to_group(GroupConstants.DRIFTS)

func _physics_process(delta):
    position = position - (Vector2(1, 1).rotated(self.rotation) * speed)

func _on_Timer_timeout():
    self.queue_free()

func pulverize():
    queue_free()

func _on_pellet_body_entered(body: AsteroidScreenInstance):
    if not body:
        return
    bullet_with_asteroids_rule.apply_rule(self,body)

func set_new_position(pos: Vector2):
    self.position = pos

func inside_play_area():
    pass
