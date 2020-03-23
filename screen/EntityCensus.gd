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
    if(entities_on_screen.has(screen_id)):
        var entity_list : Array = entities_on_screen[screen_id]
        if(entity_list.size() < max_number_of_entities_per_entry):
            entity_list.push_front(entity)
            print_debug("Added a new entity to the census with screen id: " + str(screen_id))
            print_debug("Current entities with that same screen id: " + str(entities_on_screen[screen_id]))
        else:
            printerr("Attempted to exceed max allowed entities in census: " + entity.name + " with screen id: " + screen_id)
    else:
        entities_on_screen[screen_id] = [entity]

func get_in_census(screen_id):
    if(entities_on_screen.has(screen_id)):
        return entities_on_screen[screen_id].duplicate(true)
    else:
        printerr("Requested an entity list with a screen_id that wasn't found in the census: " + str(screen_id))
