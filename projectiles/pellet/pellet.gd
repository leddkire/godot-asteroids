extends Area2D

export var speed : int = 10

func _ready():
    set_physics_process(true)

func _physics_process(delta):
    position = position - (Vector2(1, 1).rotated(self.rotation) * speed)


func _on_Timer_timeout():
    self.queue_free()
