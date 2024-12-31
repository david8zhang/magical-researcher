class_name GameOver
extends Node2D

@onready var start_over_button = $CanvasLayer/StartOver as Button

func _ready():
	start_over_button.pressed.connect(start_over)

func start_over():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")