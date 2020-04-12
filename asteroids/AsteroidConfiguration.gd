extends Node

onready var splitting_rule = preload("res://rules/splitting/AsteroidSplittingRule.gd").new()
onready var screenwrap_rule = preload("res://rules/screen_wrap/EntityScreenWrapRule.gd").new()

func autowire(asteroid):
    asteroid.splitting_rule = splitting_rule
    asteroid.screenwrap_rule = screenwrap_rule
