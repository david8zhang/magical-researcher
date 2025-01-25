class_name EnemyManager
extends Node2D

@export var basic_enemy: PackedScene

static var instance

var ENEMY_MAP = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	EnemyManager.instance = self
	ENEMY_MAP["BASIC_ENEMY"] = basic_enemy

func create_enemy(enemy_type: String):
	var enemy_scene = ENEMY_MAP[enemy_type] as PackedScene
	var enemy = enemy_scene.instantiate() as Enemy
	return enemy