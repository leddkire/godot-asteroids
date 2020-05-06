class_name AsteroidFactory

var scene
var screenwrap_rule: EntityScreenWrapRule


func _init(screenwrap_rule: EntityScreenWrapRule):
    self.scene = load("res://asteroids/Asteroid.tscn")
    self.screenwrap_rule = screenwrap_rule

func create(parent_node: Node, position: Vector2, size: String):
    var new_asteroid = scene.instance()
    new_asteroid.connect("asteroid_destroyed", EndGameRule, "_on_asteroid_destroyed")
    parent_node.add_child(new_asteroid)
    var splitting_rule = load("res://rules/splitting/AsteroidSplittingRule.gd").new(self)
    new_asteroid.initialize(splitting_rule, screenwrap_rule, position, size)
    return new_asteroid
