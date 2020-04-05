extends Node

signal ship_collided_with_asteroid
const ships_in_game = 9
var received_signals = 0

func _ready():
    pass

func ship_collided_with_asteroid():
    received_signals = received_signals + 1
    if(received_signals == ships_in_game):
        print_debug("Emitting antenna signal")
        emit_signal("ship_collided_with_asteroid")
        reset_signal_counter()

func reset_signal_counter():
    received_signals = 0
