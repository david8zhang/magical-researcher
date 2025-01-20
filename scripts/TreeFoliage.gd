class_name TreeFoliage
extends Area2D

enum TreeType {
	SMALL,
	LARGE
}

@onready var sprite = $Sprite2D as Sprite2D
var tree_type: TreeType

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(_body: Node2D):
	sprite.self_modulate.a = 0.5

func on_body_exited(_body: Node2D):
	sprite.self_modulate.a = 1

func init(type: TreeType):
	tree_type = type
	if type == TreeType.SMALL:
		sprite.texture = load("res://assets/tree.png")
	elif type == TreeType.LARGE:
		sprite.texture = load("res://assets/big-tree.png")