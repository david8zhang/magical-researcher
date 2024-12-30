class_name Player
extends CharacterBody2D

const SPEED = 300.0

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