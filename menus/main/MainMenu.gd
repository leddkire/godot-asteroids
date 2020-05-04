extends Node2D

signal start_game
func _ready():
    $Panel/VBoxContainer/StartGame.grab_focus()


func start_game():
    emit_signal("start_game")
    self.queue_free()

func exit_to_desktop():
    get_tree().quit()
