extends RigidBody2D
class_name AsteroidScreenInstance

var screen_id
onready var splitting_rule_resource = load("res://rules/splitting/AsteroidSplittingRule.gd")
var splitting_rule: AsteroidSplittingRule

signal asteroid_hit_by_bullet

var is_center_instance

func _ready():
    self.custom_integrator = false
    add_to_group(GroupConstants.DRIFTS)
    self.splitting_rule = splitting_rule_resource.new()

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
    emit_signal("asteroid_hit_by_bullet")

func is_inside_screen():
    var screen_width = ProjectSettings.get_setting("display/window/size/width")
    var screen_height = ProjectSettings.get_setting("display/window/size/height")
    return self.position.x < screen_width and self.position.x > 0 and self.position.y < screen_height and self.position.y > 0

func set_visuals(texture):
    $Sprite.texture = texture

func set_collisions(polygon):
    $CollisionPolygon2D.set_polygon(polygon.polygons[0])
    $CollisionPolygon2D.position = Vector2(-($Sprite.texture.get_width()/2),-($Sprite.texture.get_height()/2))


