class_name Game
extends Node2D

@onready var player = $Player as Player

enum Side {
	Player,
	Enemy
}

func _ready():
	var viewport_rect = get_viewport_rect()
	player.global_position = viewport_rect.get_center()
	player.on_death.connect(handle_game_over)

func handle_game_over():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
