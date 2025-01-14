class_name SpellManager
extends Node2D

@export var basic_spell: PackedScene
static var instance

var SPELL_NAME_MAP = {}

func _ready():
	SpellManager.instance = self
	SPELL_NAME_MAP["Basic Spell"] = basic_spell

func create_spell(spell_name):
	var spell_scene = SPELL_NAME_MAP[spell_name]
	var spell = spell_scene.instantiate()
	return spell
