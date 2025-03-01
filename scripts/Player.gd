class_name Player
extends CharacterBody2D

@onready var healthbar = $CanvasLayer/HPBar as ProgressBar
@onready var expbar =$CanvasLayer/EXPBar as ProgressBar
@onready var spell_progress_menu = $CanvasLayer/SpellProgressMenu as SpellProgressMenu
@onready var spell_bind_menu = $CanvasLayer/SpellBindMenu as SpellBindMenu
@onready var level_up_menu = $CanvasLayer/LevelUpMenu as LevelUpMenu
@onready var level_label = $CanvasLayer/LevelLabel as Label
@onready var camera = $Camera2D as Camera2D
@onready var sprite = $Sprite2D as AnimatedSprite2D
var active_spell: DamageSpell

# Stats
var attack = 5
var defense = 5
var max_hp = 100
var speed = 150

var exp_points = 0
var curr_level = 1

signal on_death

enum WalkDirection {
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST
}

func _ready():
	active_spell = SpellManager.instance.basic_spell.instantiate() as BasicSpell
	add_child(active_spell)
	healthbar.max_value = max_hp
	var required_exp_points = 100 * (2 ** curr_level - 1)
	expbar.max_value = required_exp_points
	expbar.value = exp_points

	spell_progress_menu.add_progress_to_spell(active_spell)
	spell_progress_menu.force_unlock_spell(active_spell.spell_name)

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

	var walk_direction = -1
	var velocity_normalized = new_velocity.normalized()
	if velocity_normalized.x == 0 and velocity_normalized.y > 0:
		walk_direction = WalkDirection.SOUTH
	elif velocity_normalized.x == 0 and velocity_normalized.y < 0:
		walk_direction = WalkDirection.NORTH
	elif velocity_normalized.x > 0 and velocity_normalized.y == 0:
		walk_direction = WalkDirection.EAST
	elif velocity_normalized.x < 0 and velocity_normalized.y == 0:
		walk_direction = WalkDirection.WEST
	elif velocity_normalized.x < 0 and velocity_normalized.y < 0:
		walk_direction = WalkDirection.NORTHWEST
	elif velocity_normalized.x > 0 and velocity_normalized.y < 0:
		walk_direction = WalkDirection.NORTHEAST
	elif velocity_normalized.x < 0 and velocity_normalized.y > 0:
		walk_direction = WalkDirection.SOUTHWEST
	elif velocity_normalized.x > 0 and velocity_normalized.y > 0:
		walk_direction = WalkDirection.SOUTHEAST
	play_anim_based_on_direction(walk_direction)
	if new_velocity.normalized() == Vector2.ZERO:
		sprite.stop()

	velocity = new_velocity.normalized() * speed
	move_and_slide()
	if Input.is_action_just_pressed("toggle_spell_menu"):
		if spell_progress_menu.visible:
			spell_progress_menu.hide()
		else:
			spell_progress_menu.show()
	if Input.is_action_just_pressed("toggle_stat_menu"):
		if level_up_menu.visible:
			level_up_menu.hide()
		else:
			level_up_menu.show_menu(self)

func play_anim_based_on_direction(direction: WalkDirection):
	match direction:
		WalkDirection.NORTH:
			sprite.play("walk-back")
		WalkDirection.SOUTH:
			sprite.play("walk-front")
		WalkDirection.WEST:
			sprite.flip_h = true
			sprite.play("walk-side")
		WalkDirection.EAST:
			sprite.flip_h = false
			sprite.play("walk-side")
		WalkDirection.NORTHWEST:
			sprite.flip_h = false
			sprite.play("walk-northwest")
		WalkDirection.NORTHEAST:
			sprite.flip_h = true
			sprite.play("walk-northwest")
		WalkDirection.SOUTHWEST:
			sprite.flip_h = true
			sprite.play("walk-southeast")
		WalkDirection.SOUTHEAST:
			sprite.flip_h = false
			sprite.play("walk-southeast")

func _input(event):
	# Ignore click events if spell book is open
	if spell_progress_menu.visible or level_up_menu.visible:
		return
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
		on_level_up()

func on_level_up():
	level_label.text = "Lv. " + str(curr_level)
	level_up_text_effect()
	expbar.max_value = 100 * 2 ** (curr_level - 1)
	level_up_menu.num_stat_points += 1

func level_up_text_effect():
	var label = Label.new()
	label.text = "Level up!"
	label.global_position = Vector2(global_position.x, global_position.y)
	label.top_level = true
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	label.global_position.x -= label.size.x / 2
	label.global_position.y -= label.size.y / 2
	var tween = create_tween()
	var final_y_pos = label.global_position.y - 20
	tween.tween_property(label, "global_position:y", final_y_pos, 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0, 1.5)
	var on_complete = Callable(self, "_on_level_up_text_effect_complete").bind(label)
	tween.finished.connect(on_complete)

func _on_level_up_text_effect_complete(label: Label):
	label.queue_free()
