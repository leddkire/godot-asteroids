extends "res://addons/gut/test.gd"

var sut: EntityCensus
onready var scene = load("res://screen/EntityCensus.gd")

func before_each():
    self.sut = scene.new()

func test_value_of_first_issued_id():
    var expected_id = 0
    assert_eq(sut.issue_new_id(), expected_id)

func test_issued_ids_in_sequence():
    var expected_id_set = {0: 0, 1: 1}

    var result_set = {}
    var first_id = sut.issue_new_id()
    result_set[first_id] = first_id

    var second_id = sut.issue_new_id()
    result_set[second_id] = second_id
    
    assert_eq(result_set.hash(), expected_id_set.hash())

func test_three_issued_ids_in_sequence():
    var expected_id_set = {0: 0, 1: 1, 2: 2}
    var result_set = {}

    var first_id = sut.issue_new_id()
    var second_id = sut.issue_new_id()
    var third_id = sut.issue_new_id()

    result_set[first_id] = first_id
    result_set[second_id] = second_id
    result_set[third_id] = third_id

    assert_eq(result_set.hash(), expected_id_set.hash())