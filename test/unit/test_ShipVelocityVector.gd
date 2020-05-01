extends "res://addons/gut/test.gd"

var scene = load("res://ship/ShipVelocityVector.gd")

func test_update_with_no_movement():
    # Given
    var moving_forward = false
    var rotation = Vector2(0,0)
    var vector = Vector2(1,1)
    var delta = .1

    var sut = scene.new(moving_forward, rotation, vector, delta)

    # When
    var result = sut.calculate()

    # Then
    assert_eq(result, vector)

