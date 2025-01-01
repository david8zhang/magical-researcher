class_name SpellManager
extends Node2D

@export var basic_spell: PackedScene
static var instance

func _ready():
	SpellManager.instance = self
