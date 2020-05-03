extends Node
class_name BulletsWithAsteroidsRule

var particles = preload("res://asteroids/PulverizedParticles.tscn")
var sound = preload("res://asteroids/PulverizedSound.tscn")

func _ready():
    pass

func apply_rule(bullet, asteroid_screen_instance):
    var instanced_particles = particles.instance()
    instanced_particles.global_position = asteroid_screen_instance.global_position
    bullet.get_parent().add_child(instanced_particles)

    var instanced_sound = sound.instance()
    bullet.get_parent().add_child(instanced_sound)
    instanced_sound.play()

    asteroid_screen_instance.call_deferred("split")
    bullet.pulverize()
