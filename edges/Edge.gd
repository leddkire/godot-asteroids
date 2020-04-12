extends Area2D
class_name Edge

var orientation
signal edge_exited(orientation, body, side_exited)

var inner_side : Vector2
var outer_side : Vector2

func _ready():
    add_to_group("edges")
    connect("body_exited",self,"_on_collision_area_body_exited")
    connect("area_exited",self,"_on_collision_area_body_exited")
    inner_side = self.get_node("inner_side").position
    outer_side = self.get_node("outer_side").position

func _on_collision_area_body_exited(body : CollisionObject2D):
    #print_debug(body.name + " exited: " + self.name )
    var side_exited : int = _determine_side_exited(body.position)
    call_deferred("emit_signal","edge_exited",orientation, body, side_exited)

func _determine_side_exited(body_position : Vector2):
    var distance_to_inner_side : float = body_position.distance_to(inner_side)
    var distance_to_outer_side : float = body_position.distance_to(outer_side)
    if distance_to_inner_side < distance_to_outer_side:
        return Edge_Side.INNER
    elif distance_to_inner_side > distance_to_outer_side:
        return Edge_Side.OUTER
    else:
        print_debug("Sides are equidistant to body. Maybe this shouldn't happen")
        return Edge_Side.INNER
