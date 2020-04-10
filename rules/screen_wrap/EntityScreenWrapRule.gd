class_name EntityScreenWrapRule

var SCREEN_WIDTH
var SCREEN_HEIGHT

func _init():
    SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/width")
    SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/height")

func reposition_around(object,unduplicated_list):
    assert(unduplicated_list.size() == 8)
    var deep_copy = true
    var objects = unduplicated_list.duplicate(deep_copy)
    for position in positions_around_screen(object):
        object = objects.pop_front()
        if is_instance_valid(object):
            object.set_new_position(position)

func positions_around_screen(object):
    var left_side_of_screen = Vector2(object.position.x + SCREEN_WIDTH, object.position.y)
    var right_side_of_screen = Vector2(object.position.x - SCREEN_WIDTH, object.position.y)
    var top_side_of_screen = Vector2(object.position.x, object.position.y + SCREEN_HEIGHT)
    var bottom_side_of_screen = Vector2(object.position.x ,object.position.y - SCREEN_HEIGHT)
    var top_right_corner_of_screen = Vector2(object.position.x + SCREEN_WIDTH, object.position.y - SCREEN_HEIGHT)
    var top_left_corner_of_screen = Vector2(object.position.x - SCREEN_WIDTH, object.position.y - SCREEN_HEIGHT)
    var bottom_right_corner_of_screen = Vector2(object.position.x + SCREEN_WIDTH, object.position.y + SCREEN_HEIGHT)
    var bottom_left_corner_of_screen = Vector2(object.position.x - SCREEN_WIDTH, object.position.y + SCREEN_HEIGHT)

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
