extends Node

const INNER = 0
const OUTER = 1

func to_name(value : int):
    match value:
        INNER:
            return "INNER"
        OUTER:
            return "OUTER"