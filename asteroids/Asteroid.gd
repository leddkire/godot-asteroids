extends Node
class_name Asteroid

var screen_id
var size

onready var splitting_rule_resource = load("res://rules/splitting/AsteroidSplittingRule.gd")
var splitting_rule: AsteroidSplittingRule
var screenwrap_rule: EntityScreenWrapRule
var asteroid_instances = []

func _ready():
    AsteroidConfiguration.autowire(self)
    assert(splitting_rule != null)
    assert(screenwrap_rule != null)
    for child in get_children():
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
    printerr("Not implemented")
    pass

func can_be_split():
    printerr("Not implemented")
    pass
    #return splitting_rule.can_be_split(self)

func split():
    pass
    #return splitting_rule.split(self)


