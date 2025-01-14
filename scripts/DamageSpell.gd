class_name DamageSpell
extends Node2D

@onready var game = get_node("/root/Main") as Game

var caster
var spell_range: int
var cooldown_seconds: float
var spell_name: String
var unlock_cost = 5
var spell_icon_path: String

func cast(_start_position: Vector2, _target_position: Vector2, _side: Game.Side):
	pass