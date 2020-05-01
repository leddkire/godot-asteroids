extends Node
class_name BulletsWithAsteroidsRule

var particles = preload("res://asteroids/PulverizedParticles.tscn")

func _ready():
    pass

func apply_rule(bullet, asteroid_screen_instance):
    var instanced_particles = particles.instance()
    instanced_particles.global_position = asteroid_screen_instance.global_position
    bullet.get_parent().add_child(instanced_particles)
    asteroid_screen_instance.call_deferred("split")
    bullet.pulverize()
