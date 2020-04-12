extends RigidBody2D
class_name AsteroidScreenInstance

var screen_id
onready var splitting_rule_resource = load("res://rules/splitting/AsteroidSplittingRule.gd")
var splitting_rule: AsteroidSplittingRule

func _ready():
    self.custom_integrator = false
    add_to_group(GroupConstants.DRIFTS)
    self.splitting_rule = splitting_rule_resource.new()

func initialize(initial_size):
        print_debug("Initialized new asteroid screen instance: " + self.name)

func set_new_position(pos: Vector2):
    var current_velocity = self.linear_velocity
    # The empty _integrate_forces method ensures that the body doesn't move
    self.custom_integrator = true
    self.global_transform.origin = pos
    self.linear_velocity = current_velocity
    self.custom_integrator = false # Restore physics processing on body

func _integrate_forces(state):
    # Empty because we want the body to stop moving.
    pass

func pulverize():
    queue_free()

func can_be_split() -> bool:
    return splitting_rule.can_be_split(self)

func split():
    return splitting_rule.split(self)
