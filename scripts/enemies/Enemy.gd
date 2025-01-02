class_name Enemy
extends RigidBody2D

var vision_radius
var active_spell: DamageSpell
var at_position_buffer = 2
var speed = 250

enum RoamingState {
	WALK,
	IDLE
}
var roam_dest = null
var roam_wait_time = -1
var roam_state = RoamingState.IDLE

signal on_death

@onready var game = get_node("/root/Main") as Game
@onready var healthbar = $ProgressBar as ProgressBar

func move_to_position(target_position: Vector2):
	var dist_to_target = global_position.distance_to(target_position)
	if dist_to_target > at_position_buffer:
		var vector_to_target = target_position - global_position
		linear_velocity = vector_to_target.normalized() * speed
	else:
		linear_velocity = Vector2.ZERO

func roam_around():
	if roam_state == RoamingState.WALK:
		if roam_dest == null:
			roam_dest = _get_random_destination()
		var dist_to_roam_dest = global_position.distance_to(roam_dest)
		if dist_to_roam_dest > 5:
			move_to_position(roam_dest)
		else:
			linear_velocity = Vector2.ZERO
			roam_dest = null
			roam_state = RoamingState.IDLE
	elif roam_state == RoamingState.IDLE:
		if roam_wait_time == -1:
			roam_wait_time = randi_range(1, 3)
			var wait_timer = Timer.new()
			wait_timer.one_shot = true
			wait_timer.autostart = true
			wait_timer.wait_time = roam_wait_time
			wait_timer.timeout.connect(end_roam_wait)
			add_child(wait_timer)

func end_roam_wait():
	roam_wait_time = -1
	roam_state = RoamingState.WALK

func _get_random_destination():
	var x_diff = randi_range(50, 200) * (-1 if randi_range(0, 1) == 0 else 1)
	var y_diff = randi_range(50, 200) * (-1 if randi_range(0, 1) == 0 else 1)
	return Vector2(global_position.x + x_diff, global_position.y + y_diff)

func take_damage(damage):
	healthbar.value -= damage
	if healthbar.value == 0:
		on_death.emit()
		queue_free()
