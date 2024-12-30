class_name Game
extends Node2D

@onready var player = $Player as Player

func _ready():
	var viewport_rect = get_viewport_rect()
	player.global_position = viewport_rect.get_center()
