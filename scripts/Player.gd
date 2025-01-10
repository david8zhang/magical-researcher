class_name Player
extends CharacterBody2D

@onready var healthbar = $CanvasLayer/HPBar as ProgressBar
@onready var expbar =$CanvasLayer/EXPBar as ProgressBar
@onready var level_label = $CanvasLayer/LevelLabel as Label
@onready var camera = $Camera2D as Camera2D
var active_spell: DamageSpell

# Stats
var attack = 5
var defense = 5
var max_hp = 100
var speed = 150

var exp_points = 0
var curr_level = 1

signal on_death

func _ready():
	active_spell = SpellManager.instance.basic_spell.instantiate() as BasicSpell
	healthbar.max_value = max_hp
	add_child(active_spell)
	var required_exp_points = 100 * (2 ** curr_level - 1)
	expbar.max_value = required_exp_points
	expbar.value = exp_points

func _physics_process(_delta):
	var new_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		new_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		new_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		new_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		new_velocity.y -= 1
	velocity = new_velocity.normalized() * speed
	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if active_spell != null:
				active_spell.cast(global_position, convert_to_world_pos(event.position), Game.Side.Player)

func convert_to_world_pos(mouse_position: Vector2):
	var origin = get_viewport_rect().get_center()
	var x_diff = mouse_position.x - origin.x
	var y_diff = mouse_position.y - origin.y
	return Vector2(global_position.x + x_diff, global_position.y + y_diff)

func take_damage(damage: int) -> void:
	healthbar.value -= damage
	if healthbar.value == 0:
		on_death.emit()

func gain_exp(exp_value: int) -> void:
	var levels_gained = 0
	var total_after_gain = expbar.value + exp_value
	var required_for_next_level = expbar.max_value
	while total_after_gain >= required_for_next_level:
		total_after_gain -= required_for_next_level
		levels_gained += 1
		required_for_next_level = 100 * 2 ** (curr_level + levels_gained)
	expbar.value = total_after_gain
	curr_level += levels_gained
	if levels_gained > 0:
		level_label.text = "Lv. " + str(curr_level)
		expbar.max_value = 100 * 2 ** (curr_level - 1)
