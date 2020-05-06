class_name EntityScreenWrapRule

var PLAY_AREA_WIDTH
var PLAY_AREA_HEIGHT
const SCREEN_ENTITIES_MINUS_CENTER = 8

func _init():
    PLAY_AREA_WIDTH = ProjectSettings.get_setting("display/window/size/width")
    PLAY_AREA_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

func reposition_around(new_center_instance,unduplicated_list):
    assert(unduplicated_list.size() == SCREEN_ENTITIES_MINUS_CENTER)
    var deep_copy = true
    var objects = unduplicated_list.duplicate(deep_copy)

    new_center_instance.is_center_instance = true
    for position in positions_around_screen(new_center_instance):
        var object = objects.pop_front()
        if is_instance_valid(object):
            object.set_new_position(position)
            object.is_center_instance = false

func positions_around_screen(object):
    var left_side_of_screen = Vector2(object.position.x + PLAY_AREA_WIDTH, object.position.y)
    var right_side_of_screen = Vector2(object.position.x - PLAY_AREA_WIDTH, object.position.y)
    var top_side_of_screen = Vector2(object.position.x, object.position.y + PLAY_AREA_HEIGHT)
    var bottom_side_of_screen = Vector2(object.position.x ,object.position.y - PLAY_AREA_HEIGHT)
    var top_right_corner_of_screen = Vector2(object.position.x + PLAY_AREA_WIDTH, object.position.y - PLAY_AREA_HEIGHT)
    var top_left_corner_of_screen = Vector2(object.position.x - PLAY_AREA_WIDTH, object.position.y - PLAY_AREA_HEIGHT)
    var bottom_right_corner_of_screen = Vector2(object.position.x + PLAY_AREA_WIDTH, object.position.y + PLAY_AREA_HEIGHT)
    var bottom_left_corner_of_screen = Vector2(object.position.x - PLAY_AREA_WIDTH, object.position.y + PLAY_AREA_HEIGHT)

    return [
        left_side_of_screen,
        right_side_of_screen,
        top_side_of_screen,
        bottom_side_of_screen,
        top_left_corner_of_screen,
        top_right_corner_of_screen,
        bottom_left_corner_of_screen,
        bottom_right_corner_of_screen
    ]
