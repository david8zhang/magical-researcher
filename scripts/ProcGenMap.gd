class_name ProcGenMap
extends TileMap

var altitude = FastNoiseLite.new()
var moisture = FastNoiseLite.new()

# chunk width and height in tiles
var chunk_width = 64
var chunk_height = 64

@onready var game = get_node("/root/Main") as Game

var loaded_chunks = []

func _ready():
	altitude.seed = randi()
	altitude.frequency = 0.005

func _process(_delta):
	var player = game.player
	var player_tile_pos = local_to_map(player.global_position)
	generate_chunk(player_tile_pos)
	unload_distant_chunks(player_tile_pos)

func generate_chunk(pos: Vector2):
	for x in range(chunk_width):
		for y in range(chunk_height):

			var tile_x = pos.x - (chunk_width / 2) + x
			var tile_y = pos.y - (chunk_height / 2) + y

			# Generate an integer between -10 and 10
			var alt = altitude.get_noise_2d(tile_x, tile_y) * 10
			var moist = moisture.get_noise_2d(tile_x, tile_y) * 10

			# Convert to a number between 0 and 2 (inclusive)
			var moist_normalized = round((moist + 10) / 20)

			var dark_grass_tile_index = Vector2i(0, 0)
			var dirt_tile_index = Vector2i(0, 1)
			var light_grass_tile_index = Vector2i(0, 2)

			var tile_index = light_grass_tile_index
			if alt < 0:
				tile_index = dark_grass_tile_index
			else:
				if moist_normalized == 0:
					tile_index = dirt_tile_index
				elif moist_normalized == 1:
					tile_index = light_grass_tile_index

			set_cell(0, Vector2i(tile_x, tile_y), 0, tile_index)

			# Add chunk to loaded chunks
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))

func unload_distant_chunks(player_pos):
	var unload_dist = (chunk_width * 2) + 1
	for chunk in loaded_chunks:
		var dist_to_player = dist(chunk, player_pos)
		if dist_to_player > unload_dist:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)

func clear_chunk(pos):
		for x in range(chunk_width):
			for y in range(chunk_height):
				# Clear tile by setting to -1, -1
				set_cell(0, Vector2i(pos.x - (chunk_width / 2) + x, pos.y - (chunk_height / 2) + y), -1, Vector2(-1, -1))

func dist(p1, p2):
	var r = p1 - p2
	return sqrt(r.x ** 2 + r.y ** 2)