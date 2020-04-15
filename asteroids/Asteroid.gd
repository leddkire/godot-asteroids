extends Node
class_name Asteroid

var screen_id
var size

var splitting_rule: AsteroidSplittingRule
var screenwrap_rule: EntityScreenWrapRule
var asteroid_instances = []

onready var ignoring_signals = false
onready var signal_counter = 0

signal asteroid_destroyed

func _ready():
    AsteroidConfiguration.autowire(self)
    assert(splitting_rule != null)
    assert(screenwrap_rule != null)
    for child in get_children():
        var asteroid_screen_instance = child as AsteroidScreenInstance
        if asteroid_screen_instance != null:
            asteroid_screen_instance.connect("asteroid_hit_by_bullet", self, "_on_asteroid_hit_by_bullet")
            asteroid_instances.push_front(asteroid_screen_instance)

func initialize(initial_position: Vector2, initial_size: String):
    self.size = initial_size
    self.screen_id = EntityCensus.issue_new_id()

    var x_velocity = randi() % 60
    var y_velocity = randi() % 60
    var linear_velocity = Vector2(random_sign() * x_velocity, random_sign() * y_velocity)

    for instance in asteroid_instances:
        instance.screen_id = self.screen_id
        instance.linear_velocity = linear_velocity
        EntityCensus.add_entity_to_census(instance)

    $initial_center_instance.set_new_position(initial_position)

    var surrounding_instances = asteroid_instances.duplicate(true)
    surrounding_instances.erase($initial_center_instance)
    screenwrap_rule.reposition_around($initial_center_instance, surrounding_instances)

    print_debug("Initialized new asteroid: " + self.name + " with size: " + size)

func pulverize():
    if(self.size == "S"):
        emit_signal("asteroid_destroyed")
    queue_free()

func split():
    return splitting_rule.split(self)

func _on_asteroid_hit_by_bullet():
    signal_counter += 1
    print("Asteroid signal hit by bullet: " + str(signal_counter))
    if(signal_counter == asteroid_instances.size()):
        split()
        pulverize()
        signal_counter = 0

func visible_instance_position():
    for instance in asteroid_instances:
        if(instance.is_center_instance):
            return instance.position
    printerr("No asteroid instance found on screen.")
    return null

func random_sign():
    var random_sign = randi() % 2
    if random_sign == 0:
        return -1
    else:
        return 1
