extends "res://addons/gut/test.gd"

onready var sut_scene = preload("res://ship/ship.tscn")
onready var ship_instance_scene = preload("res://ship/ShipInstance.tscn") 
var sut: Ship

func before_each():
    sut = add_child_autoqfree(sut_scene.instance())

func test_ship_disappears_after_invincibility_runs_out_and_its_exploding():
    # Given
    var other_sut = sut_scene.instance()
    other_sut.exploding = true

    # When
    other_sut._on_invincibility_timeout()

    # Then
    assert_true(other_sut.is_queued_for_deletion())

func test_ship_instances_become_vincible_after_invincibility_runs_out():
    # Given
    sut.instances = double_instances(sut.instances)

    # When
    sut._on_invincibility_timeout()

    for instance in sut.instances:
        assert_called(instance, "become_vincible")

func test_explode_sets_flag():
    # Given
    # When
    sut.explode()
    
    # Then
    assert_eq(sut.exploding, true)

func test_explode_sets_instances_to_explode():
    # Given
    sut.instances = double_instances(sut.instances)

    # When
    sut.explode()
    
    # Then
    for instance in sut.instances:
        assert_called(instance, "explode")

func test_ship_counts_instance_collisions_with_asteroids():
    # Given
    sut.instance_signal_counter = 0

    # When
    sut._on_instance_collided_with_asteroid()

    # Then
    sut.instance_signal_counter = 1

func test_ship_collides_with_asteroid_when_all_instances_did():
    # Given
    sut.instance_signal_counter = sut.instances.size() - 1
    watch_signals(sut)

    # When
    sut._on_instance_collided_with_asteroid()

    # Then
    assert_signal_emitted(sut, "ship_collided_with_asteroid")


func double_instances(instances: Array) -> Array:
    var doubled_instances = []
    for i in range(instances.size()):
        doubled_instances.append(partial_double(ship_instance_scene).instance())
    return doubled_instances

