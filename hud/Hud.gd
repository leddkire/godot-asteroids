extends Node

func _ready():
    pass # Replace with function body.

func set_player_lives(lives):
    $Panel/HBoxContainer/Lives.text = str(lives)
