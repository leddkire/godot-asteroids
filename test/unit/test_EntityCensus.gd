extends "res://addons/gut/test.gd"

var sut: EntityCensus
onready var scene = load("res://screen/EntityCensus.gd")

func before_each():
    self.sut = scene.new()

func test_value_of_first_issued_id():
    #Given
    var expected_id = 0
    #When
    var issued_id = sut.issue_new_id()
    #Then
    assert_eq(issued_id, expected_id)

func test_issued_ids_in_sequence():
    #Given
    var expected_id_set = {0: 0, 1: 1}
    var result_set = {}
    #when
    var first_id = sut.issue_new_id()
    result_set[first_id] = first_id

    var second_id = sut.issue_new_id()
    result_set[second_id] = second_id
    #Then
    assert_eq(result_set.hash(), expected_id_set.hash())

func test_three_issued_ids_in_sequence():
    #Given
    var expected_id_set = {0: 0, 1: 1, 2: 2}
    var result_set = {}
    #When
    var first_id = sut.issue_new_id()
    var second_id = sut.issue_new_id()
    var third_id = sut.issue_new_id()

    result_set[first_id] = first_id
    result_set[second_id] = second_id
    result_set[third_id] = third_id
    #Then
    assert_eq(result_set.hash(), expected_id_set.hash())

func test_adds_one_entity_to_empty_census():
    #Given
    var screen_id = "id_for_entity"
    #When
    var census = add_to_census(entities_with_same_screen_id(1, screen_id))
    #Then
    assert_eq(census[screen_id].size(), 1)

func test_adds_two_entities_with_same_screen_id():
    #Given
    var screen_id = "id_for_identity"
    #When
    var census = add_to_census(entities_with_same_screen_id(2, screen_id))
    #Then
    assert_eq(census[screen_id].size(), 2)

func test_adds_two_entities_with_distinct_ids():
    #Given
    var one_screen_id = "id_1"
    var another_screen_id = "id_2"
    #When
    add_to_census(entities_with_same_screen_id(1, one_screen_id))
    var census = add_to_census(entities_with_same_screen_id(1, another_screen_id))
    #Then
    assert_eq(census[one_screen_id].size(), 1)
    assert_eq(census[another_screen_id].size(), 1)

func test_get_in_census_returns_entities_with_screen_id():
    #Given
    var screen_id = "test_id"
    var test_census = entities_with_same_screen_id(3, screen_id)
    add_to_census(test_census)
    #When
    var census_entry = sut.get_in_census(screen_id)
    #Then
    assert_eq(census_entry, test_census)

func test_get_in_census_when_no_entities_match_screen_id():
    #Given
    var screen_id = "test_id"
    var test_census = []
    add_to_census(test_census)
    #When
    var census_entry = sut.get_in_census(screen_id)
    #Then
    assert_eq(census_entry, test_census)

func test_clear_census():
    #Given
    var screen_id = "test_id"
    var test_census = entities_with_same_screen_id(3, screen_id)
    add_to_census(test_census)
    #When
    sut.clear()
    var census_entry = sut.get_in_census(screen_id)
    #Then
    assert_eq(census_entry, [])

func entities_with_same_screen_id(amount: int, screen_id: String):
    var entities = []
    for _i in range(amount):
        var entity = Asteroid.new()
        entity.screen_id = screen_id
        entities.append(entity)
    return entities

func add_to_census(entities: Array):
    var census
    for e in entities:
        census = sut.add_entity_to_census(e)
    return census

    


