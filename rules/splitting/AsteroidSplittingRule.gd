class_name AsteroidSplittingRule

var scene

var asteroid_splitting_table = {
    "L": {
        "shapes": [],
        "pieces_to_split": 2,
        "next_size": "M"
    },
    "M": {
        "shapes": [],
        "pieces_to_split": 2,
        "next_size": "S"
    },
    "S": {
        "shapes": [],
        "pieces_to_split": 2,
        "next_size": null
    }
}

func _init():
    scene = load("res://asteroids/Asteroid.tscn")

func can_be_split(asteroid) -> bool:
    var next_size = asteroid_splitting_table[asteroid.size]["next_size"]
    return next_size != null

func split(asteroid):
    if(can_be_split(asteroid)):
        var splitting_info = asteroid_splitting_table[asteroid.size]
        var pieces_to_split = splitting_info["pieces_to_split"]

        var split_asteroids = []
        for i in range(pieces_to_split):
            #print_debug("Splitting piece #" + str(i) + " from asteroid: " + self.name + " with size: " + size)
            var new_asteroid = scene.instance()
            new_asteroid.size = splitting_info["next_size"]
            new_asteroid.screen_id = str(asteroid.screen_id) + "_" + str(i)
            new_asteroid.position = asteroid.position
            EntityCensus.add_entity_to_census(new_asteroid)
            split_asteroids.append(new_asteroid)
            asteroid.get_parent().add_child(new_asteroid)
            #asteroid.get_parent().call_deferred('add_child',new_asteroid)
        asteroid.queue_free()
        return split_asteroids
    else:
        print_debug("An asteroid was expected to split, but it couldn't.")
        return []
