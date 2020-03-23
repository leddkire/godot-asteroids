class_name EntityScreenWrapRule

func _init():
    pass

func reposition_around(object,objects):
    var screen_width = ProjectSettings.get_setting("display/window/size/width")
    var screen_height = ProjectSettings.get_setting("display/window/size/height")
    #Position to the left
    position_object(objects.pop_front(),object.position.x + screen_width,object.position.y)
    #Position to the right
    position_object(objects.pop_front(),object.position.x - screen_width, object.position.y)
    #Position to the top
    position_object(objects.pop_front(),object.position.x, object.position.y + screen_height)
    #Position to the bottom
    position_object(objects.pop_front(),object.position.x,object.position.y - screen_height)
    #Position to the top-right corner
    position_object(objects.pop_front(),object.position.x + screen_width,object.position.y - screen_height)
    #Position to the top-left corner
    position_object(objects.pop_front(),object.position.x - screen_width,object.position.y - screen_height)
    #Position to the bottom-right corner
    position_object(objects.pop_front(),object.position.x + screen_width,object.position.y + screen_height)
    #Position to the bottom-left corner
    position_object(objects.pop_front(),object.position.x - screen_width,object.position.y + screen_height)

func position_object(object,x_value,y_value):
    object.set_new_position(Vector2(x_value, y_value))
