extends "res://addons/gut/test.gd"

var ship_instance: ShipInstance
onready var scene = load("res://ship/ShipInstance.tscn")

func before_each():
    self.ship_instance = scene.instance()
    # Given
    var ship_instance: ShipInstance = load("res://ship/ShipInstance.tscn").instance()

    # When
    ship_instance.become_invincible()

    # Then
    var animation_player: AnimationPlayer = ship_instance.get_node("AnimationPlayer")
    assert_eq(animation_player.current_animation, ship_instance.invincibility_animation)

func test_vincibility_animation():
    # When
    ship_instance.become_vincible()

    # Then
    var animation_player: AnimationPlayer = ship_instance.get_node("AnimationPlayer")
    assert_eq(animation_player.current_animation, ship_instance.idle_animation)

func test_collisions_when_invincible():
    # Given
    var doubled_object = partial_double(Node, DOUBLE_STRATEGY.FULL).new()
    replace_node(ship_instance,ship_instance.get_collision_node().name, doubled_object)

    # When
    ship_instance.become_invincible()

    # Then
    var collision_object: Node = ship_instance.get_collision_node()
    assert_called(collision_object, "set_deferred", ["monitoring", false])

func test_collisions_when_vincible():
    # When
    ship_instance.become_vincible()

    # Then
    var collision_object: Area2D = ship_instance.get_collision_node()
    assert_true(collision_object.monitoring)

