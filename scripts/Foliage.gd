class_name Foliage
extends Area2D

enum FoliageType {
	SMALL_TREE,
	LARGE_TREE,
	SHRUB,
	WEED
}

@onready var sprite = $Sprite2D as Sprite2D
@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
var foliage_type: FoliageType

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(_body: Node2D):
	if foliage_type == FoliageType.SMALL_TREE or foliage_type == FoliageType.LARGE_TREE:
		sprite.self_modulate.a = 0.5

func on_body_exited(_body: Node2D):
	if foliage_type == FoliageType.SMALL_TREE or foliage_type == FoliageType.LARGE_TREE:
		sprite.self_modulate.a = 1

func init(type: FoliageType):
	foliage_type = type
	var rect = RectangleShape2D.new()
	if type == FoliageType.SMALL_TREE:
		sprite.offset = Vector2i(-24, -96)
		collision_shape_2d.position = Vector2(0, -48)
		rect.size = Vector2(48, 96)
		sprite.texture = load("res://assets/tree.png")
	elif type == FoliageType.LARGE_TREE:
		sprite.offset = Vector2i(-32, -160)
		collision_shape_2d.position = Vector2(0, -80)
		rect.size = Vector2(64, 160)
		sprite.texture = load("res://assets/big-tree.png")
	elif type == FoliageType.SHRUB:
		sprite.offset = Vector2i(-16, -32)
		collision_shape_2d.position = Vector2(0, -16)
		rect.size = Vector2(32, 32)
		sprite.texture = load("res://assets/shrub.png")
	elif type == FoliageType.WEED:
		sprite.offset = Vector2i(-16, -32)
		collision_shape_2d.position = Vector2(0, -16)
		rect.size = Vector2(32, 32)
		sprite.texture = load("res://assets/weed.png")
	collision_shape_2d.shape = rect

