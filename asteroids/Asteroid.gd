extends RigidBody2D

var screen_id

func _ready():
    self.custom_integrator = false
    add_to_group(GroupConstants.DRIFTS)

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
