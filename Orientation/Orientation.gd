extends Node

const North = 0
const South = 1
const East = 2
const West = 3

func to_name(orientation):
    match orientation:
        Orientation.North:
            return "North"
        Orientation.South:
            return "South"
        Orientation.East:
            return "East"
        Orientation.West:
            return "West"
