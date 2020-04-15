class_name AsteroidSplittingRule

var factory

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
    factory = load("res://asteroids/AsteroidFactory.gd").new()

func can_be_split(asteroid) -> bool:
    var next_size = asteroid_splitting_table[asteroid.size]["next_size"]
    return next_size != null

func split(asteroid):
    var split_asteroids = []
    if(can_be_split(asteroid)):
        var splitting_info = asteroid_splitting_table[asteroid.size]

        for _i in range(splitting_info["pieces_to_split"]):
            #print_debdug("Splitting piece #" + str(i) + " from asteroid: " + self.name + " with size: " + size)
            split_asteroids.append(factory.create(asteroid.get_parent(), asteroid.visible_instance_position(), splitting_info["next_size"]))

    return split_asteroids

func random_sign():
    var random_sign = randi() % 2
    if random_sign == 0:
        return -1
    else:
        return 1
