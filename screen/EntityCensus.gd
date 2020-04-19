extends Node

var entities_on_screen : Dictionary = {}
var asteroids_on_screen: Dictionary = {}

var last_id_issued = -1

var constants = preload("res://screen/ScreenWrapConstants.gd").new()
var max_number_of_entities_per_entry = constants.INSTANCES_ON_SCREEN

func issue_new_id():
    last_id_issued+=1
    #print_debug("Issued a new screen id")
    return last_id_issued

func add_entity_to_census(entity):
    var screen_id = entity.screen_id
    if _is_in_census(entity.screen_id):
        var entity_list : Array = census_entry(entity.screen_id)
        if _within_maximum_allowed_entities(entity_list.size()):
                _add_to_existing_census_entry(entity)
        else:
            printerr("Attempted to exceed max allowed entities in census: " + entity.name + " with screen id: " + screen_id)
    else:
        _add_new_census_entry(entity)
    return entities_on_screen

func _is_in_census(screen_id):
    return entities_on_screen.has(screen_id)

func census_entry(screen_id):
    return entities_on_screen[screen_id]

func _within_maximum_allowed_entities(census_entry_size):
    return census_entry_size  < self.max_number_of_entities_per_entry

func _add_to_existing_census_entry(entity):
    entities_on_screen[entity.screen_id].push_front(weakref(entity))
    var asteroid_instance = entity as AsteroidScreenInstance
    if asteroid_instance :
        asteroids_on_screen[entity.screen_id].push_front(weakref(entity))
    #print_debug("Added a new entity to the census with screen id: " + str(entity.screen_id))
    #print_debug("Current entities with that same screen id: " + str(entities_on_screen[entity.screen_id]))

func _add_new_census_entry(entity):
    var ref = weakref(entity)
    entities_on_screen[entity.screen_id] = [ref]
    var asteroid_instance = entity as AsteroidScreenInstance
    if asteroid_instance:
        asteroids_on_screen[entity.screen_id] = [ref]

func get_in_census(screen_id):
    if _is_in_census(screen_id):
        var deep_copy = true
        var entities = []
        for ref in entities_on_screen[screen_id]:
            entities.push_front(ref.get_ref())
        return entities.duplicate(deep_copy)
    else:
        printerr("Requested an entity list with a screen_id that wasn't found in the census: " + str(screen_id))
        return []

func asteroids():
    var counter = 0
    for census_entry in asteroids_on_screen.values():
        for screen_instance_ref in census_entry:
            if screen_instance_ref.get_ref():
                counter +=1
                break
    return counter


func clear():
    entities_on_screen.clear()
