class_name EnemySpawner
extends Node2D

var spawn_timer
var enemies = []

@export var max_enemies = 3
@export var time_between_spawn = 5.0
@export var enemy_type_to_spawn: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = time_between_spawn
	var cb = Callable(self, "spawn_enemy")
	spawn_timer.timeout.connect(cb)
	add_child(spawn_timer)
	spawn_timer.start()

func spawn_enemy():
	print("Spawning enemy...")
	if enemy_type_to_spawn != "" and enemies.size() < max_enemies:
		var enemy = EnemyManager.instance.create_enemy(enemy_type_to_spawn)
		enemy.global_position = Vector2(global_position.x, global_position.y)
		add_child(enemy)
		enemies.append(enemy)

func _process(_delta):
	var new_enemies = []
	for e in enemies:
		if is_instance_valid(e):
			new_enemies.append(e)
	enemies = new_enemies

func remove():
	for e in enemies:
		e.queue_free()
