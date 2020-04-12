extends Node
class_name Asteroid

var screen_id
var size

onready var splitting_rule_resource = load("res://rules/splitting/AsteroidSplittingRule.gd")
var splitting_rule: AsteroidSplittingRule
var screenwrap_rule: EntityScreenWrapRule
var asteroid_instances = []

onready var ignoring_signals = false
onready var signal_counter = 0

func _ready():
    AsteroidConfiguration.autowire(self)
    assert(splitting_rule != null)
    assert(screenwrap_rule != null)
    for child in get_children():
        var asteroid_screen_instance = child as AsteroidScreenInstance
        if asteroid_screen_instance != null:
            asteroid_screen_instance.connect("asteroid_hit_by_bullet", self, "_on_asteroid_hit_by_bullet")
            asteroid_instances.push_front(child)

func initialize(initial_position: Vector2, initial_size: String):
    self.size = initial_size
    self.screen_id = EntityCensus.issue_new_id()

    for instance in asteroid_instances:
        instance.screen_id = self.screen_id
        EntityCensus.add_entity_to_census(instance)

    $initial_center_instance.set_new_position(initial_position)

    var surrounding_instances = asteroid_instances.duplicate(true)
    surrounding_instances.erase($initial_center_instance)
    screenwrap_rule.reposition_around($initial_center_instance, surrounding_instances)

    print_debug("Initialized new asteroid: " + self.name + " with size: " + size)

func set_new_position(pos: Vector2):
    printerr("Not implemented")
    pass

func pulverize():
    queue_free()

func can_be_split():
    return splitting_rule.can_be_split(self)

func split():
    return splitting_rule.split(self)

func _on_asteroid_hit_by_bullet():
    signal_counter += 1
    print("A screen instance has signalled that I've been hit by a bullet: " + str(signal_counter))
    if(signal_counter == asteroid_instances.size()):
        if(can_be_split()):
            print("I will now split myself")
            #split()
            signal_counter = 0
        else:
            pulverize()

func signal_switch():
    ignoring_signals = true
    yield()
    ignoring_signals = false
