class_name Game
extends Node2D

@onready var player = $Player as Player
@onready var camera = $Player/Camera2D as Camera2D
@onready var canvas_layer = $CanvasLayer
@export var spell_unlock_alert_scene: PackedScene

var max_enemies = 20
var enemies_in_world = []

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

func create_new_spell_unlock_alert(spell_name: String):
	var spell_unlock_alert = spell_unlock_alert_scene.instantiate() as SpellUnlockAlert
	canvas_layer.add_child(spell_unlock_alert)
	spell_unlock_alert.set_spell_name(spell_name)
	spell_unlock_alert.show_popup()

func _process(_delta):
	var new_enemies = []
	clean_up_offscreen_enemies()
	for e in enemies_in_world:
		if is_instance_valid(e):
			new_enemies.append(e)
	enemies_in_world = new_enemies

func clean_up_offscreen_enemies():
	for e in enemies_in_world:
		if is_instance_valid(e):
			var dist_to_player = e.global_position.distance_to(player.global_position)
			if dist_to_player > camera.get_viewport_rect().size.x:
				e.queue_free()
