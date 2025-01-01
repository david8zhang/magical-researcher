class_name Player
extends CharacterBody2D

const SPEED = 300.0

@onready var healthbar = $CanvasLayer/HPBar as ProgressBar
var active_spell: DamageSpell

signal on_death

func _ready():
	active_spell = SpellManager.instance.basic_spell.instantiate() as BasicSpell
	add_child(active_spell)

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
	velocity = new_velocity.normalized() * SPEED
	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if active_spell != null:
				active_spell.cast(global_position, event.position)

func take_damage(damage: int) -> void:
	healthbar.value -= damage
	if healthbar.value == 0:
		on_death.emit()
