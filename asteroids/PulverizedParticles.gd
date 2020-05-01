extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $CPUParticles2D.emitting = true


func _process(delta):
    if(!$CPUParticles2D.emitting):
        self.queue_free()
