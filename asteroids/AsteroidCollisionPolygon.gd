extends Node

onready var cache = {}

func create_collision_polygon(texture: Resource):
    var id = texture.resource_path
    if(cache.has(id)):
        return cache[id]

    var bitmap = BitMap.new()
    bitmap.create_from_image_alpha(texture.get_data())
    var rect = Rect2(0, 0, texture.get_width(), texture.get_height())
    var my_array = bitmap.opaque_to_polygons(rect)
    var my_polygon = Polygon2D.new()
    my_polygon.set_polygons(my_array)
    cache[id] = my_polygon
    return my_polygon
