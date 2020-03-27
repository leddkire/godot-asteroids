extends Node

var entities_on_screen : Dictionary = {}

var last_id_issued = -1
const max_number_of_entities_per_entry = 9

func issue_new_id():
    last_id_issued+=1
    print_debug("Issued a new screen id")
    return last_id_issued

func add_entity_to_census(entity):
    var screen_id = entity.screen_id
    if is_in_census(entity.screen_id):
        var entity_list : Array = census_entry(entity.screen_id)
        if within_maximum_allowed_entities(entity_list.size()):
                add_to_existing_census_entry(entity_list, entity)
        else:
            printerr("Attempted to exceed max allowed entities in census: " + entity.name + " with screen id: " + screen_id)
    else:
        add_new_census_entry(entity)

func is_in_census(screen_id):
    return entities_on_screen.has(screen_id)

func census_entry(screen_id):
    return entities_on_screen[screen_id]

func within_maximum_allowed_entities(census_entry_size):
    return census_entry_size  < max_number_of_entities_per_entry

func add_to_existing_census_entry(census_entry, entity):
    census_entry.push_front(entity)
    print_debug("Added a new entity to the census with screen id: " + str(entity.screen_id))
    print_debug("Current entities with that same screen id: " + str(entities_on_screen[entity.screen_id]))

func add_new_census_entry(entity):
    entities_on_screen[entity.screen_id] = [entity]

func get_in_census(screen_id):
    if is_in_census(screen_id):
        var deep_copy = true
        return entities_on_screen[screen_id].duplicate(deep_copy)
    else:
        printerr("Requested an entity list with a screen_id that wasn't found in the census: " + str(screen_id))
