class_name ProcGenMap
extends TileMap

var altitude = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()

# chunk width and height in tiles
var chunk_width = 24
var chunk_height = 20

@onready var game = get_node("/root/Main") as Game
@export var foliage_scene: PackedScene
@export var enemy_spawner_scene: PackedScene

var loaded_chunks = []
var foliage_map = {}
var foliage_recycling_bin = {}
var enemy_spawner_map = {}

# Dark grass tile indices
var DARK_GRASS_TILE = Vector2i(0, 0)
var DARK_GRASS_NORTH_EDGE = Vector2i(1, 0)
var DARK_GRASS_WEST_EDGE = Vector2i(2, 0)
var DARK_GRASS_EAST_EDGE = Vector2i(3, 0)
var DARK_GRASS_SOUTH_EDGE = Vector2i(4, 0)
var DARK_GRASS_NORTH_EAST_CORNER = Vector2i(5, 0)
var DARK_GRASS_SOUTH_WEST_CORNER = Vector2i(6, 0)
var DARK_GRASS_NORTH_WEST_CORNER = Vector2i(7, 0)
var DARK_GRASS_SOUTH_EAST_CORNER = Vector2i(8, 0)
var DARK_GRASS_NORTH_CORNER = Vector2i(9, 0)
var DARK_GRASS_SOUTH_CORNER = Vector2i(10, 0)
var DARK_GRASS_WEST_CORNER = Vector2i(11, 0)
var DARK_GRASS_EAST_CORNER = Vector2i(12, 0)
var DARK_GRASS_TUNNEL_HORIZ = Vector2i(13, 0)
var DARK_GRASS_TUNNEL_VERT = Vector2i(14, 0)
var DARK_GRASS_PATCH = Vector2i(15, 0)

# Dirt tile indices
var DIRT_TILE = Vector2i(0, 1)
var DIRT_NORTH_EDGE = Vector2i(1, 1)
var DIRT_WEST_EDGE = Vector2i(2, 1)
var DIRT_EAST_EDGE = Vector2i(3, 1)
var DIRT_SOUTH_EDGE = Vector2i(4, 1)
var DIRT_NORTH_EAST_CORNER = Vector2i(5, 1)
var DIRT_SOUTH_WEST_CORNER = Vector2i(6, 1)
var DIRT_NORTH_WEST_CORNER = Vector2i(7, 1)
var DIRT_SOUTH_EAST_CORNER = Vector2i(8, 1)
var DIRT_NORTH_CORNER = Vector2i(9, 1)
var DIRT_SOUTH_CORNER = Vector2i(10, 1)
var DIRT_WEST_CORNER = Vector2i(11, 1)
var DIRT_EAST_CORNER = Vector2i(12, 1)
var DIRT_TUNNEL_HORIZ = Vector2i(13, 1)
var DIRT_TUNNEL_VERT = Vector2i(14, 1)
var DIRT_PATCH = Vector2i(15, 1)

# Other tiles
var GRASS_TILE = Vector2i(0, 2)
var GRASS_FLOWER_TILE = Vector2i(1, 2)
var GRASS_WEED_TILE = Vector2i(2, 2)
var DIRT_DARK_ROCK_TILE = Vector2i(3, 2)
var DIRT_LIGHT_ROCK_TILE = Vector2i(4, 2)

func _ready():
	altitude.seed = randi()
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.frequency = 0.005
	temperature.frequency = 10

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

	# Fill in corner / edge tiles
	fill_in_edges(pos)

	# Fill in foliage
	fill_in_foliage(pos)

func fill_in_edges(pos: Vector2):
	for x in range(chunk_width):
		for y in range(chunk_height):
			var tile_x = pos.x - (chunk_width / 2) + x
			var tile_y = pos.y - (chunk_width / 2) + y
			var tile_type = get_tile_type(Vector2(tile_x, tile_y))
			set_cell(0, Vector2i(tile_x, tile_y), 0, tile_type)


func fill_in_foliage(pos: Vector2):
	for x in range(chunk_width):
		for y in range(chunk_height):
			var tile_x = pos.x - (chunk_width / 2) + x
			var tile_y = pos.y - (chunk_width / 2) + y
			var tile_type = get_cell_atlas_coords(0, Vector2i(tile_x, tile_y))
			var temp_normalized = round(((temperature.get_noise_2d(tile_x, tile_y) + 1.0) * 0.5) * 25)

			# Set foliage (weeds, flowers)
			if tile_type == GRASS_TILE:
				if temp_normalized <= 5:
					set_cell(0, Vector2i(tile_x, tile_y), 0, GRASS_FLOWER_TILE)
				elif temp_normalized > 5 and temp_normalized <= 8:
					set_cell(0, Vector2i(tile_x, tile_y), 0, GRASS_WEED_TILE)
			elif tile_type == DIRT_TILE:
				if temp_normalized <= 5:
					set_cell(0, Vector2i(tile_x, tile_y), 0, DIRT_DARK_ROCK_TILE)
				elif temp_normalized > 5 and temp_normalized <= 8:
					set_cell(0, Vector2i(tile_x, tile_y), 0, DIRT_LIGHT_ROCK_TILE)
			elif tile_type == DARK_GRASS_TILE:
				var key = str(tile_x) + "," + str(tile_y)
				var world_coordinates = map_to_local(Vector2i(tile_x, tile_y))
				if !foliage_map.has(key) and temp_normalized <= 9:
					if temp_normalized == 5:
						if can_recycle_obj("WEED"):
							recycle_obj("WEED", key, world_coordinates)
						else:
							create_new_foliage_object(Foliage.FoliageType.WEED, key, world_coordinates)
					elif temp_normalized == 6:
						if can_recycle_obj("SHRUB"):
							recycle_obj("SHRUB", key, world_coordinates)
						else:
							create_new_foliage_object(Foliage.FoliageType.SHRUB, key, world_coordinates)
					elif temp_normalized == 7:
						if can_recycle_obj("SMALL_TREE"):
							recycle_obj("SMALL_TREE", key, world_coordinates)
						else:
							create_new_foliage_object(Foliage.FoliageType.SMALL_TREE, key, world_coordinates)
					elif temp_normalized == 8:
						if can_recycle_obj("LARGE_TREE"):
							recycle_obj("LARGE_TREE", key, world_coordinates)
						else:
							create_new_foliage_object(Foliage.FoliageType.LARGE_TREE, key, world_coordinates)
					elif temp_normalized == 9:
						# Space enemy spawners apart
						if !enemy_spawner_map.has(key) and dist_to_closest_enemy_spawner(world_coordinates) > 1000:
							var new_enemy_spawner = enemy_spawner_scene.instantiate() as EnemySpawner
							new_enemy_spawner.enemy_type_to_spawn = "BASIC_ENEMY"
							new_enemy_spawner.global_position = world_coordinates
							add_sibling(new_enemy_spawner)
							enemy_spawner_map[key] = new_enemy_spawner

func dist_to_closest_enemy_spawner(world_coordinates):
	var min_distance = INF
	for spawner in enemy_spawner_map.values():
		min_distance = min(min_distance, spawner.global_position.distance_to(world_coordinates))
	return min_distance

func can_recycle_obj(key_name: String):
	return foliage_recycling_bin.has(key_name) and foliage_recycling_bin[key_name].size() > 0

func recycle_obj(key_name: String, coord_key: String, world_coordinates: Vector2):
	var foliage_obj = foliage_recycling_bin[key_name].pop_back() as Foliage
	foliage_obj.visible = true
	foliage_obj.global_position = world_coordinates
	foliage_map[coord_key] = foliage_obj

func create_new_foliage_object(foliage_type: Foliage.FoliageType, coord_key: String, world_coordinates: Vector2):
	var foliage_obj = foliage_scene.instantiate() as Foliage
	add_sibling(foliage_obj)
	foliage_obj.init(foliage_type)
	foliage_obj.global_position = world_coordinates
	foliage_map[coord_key] = foliage_obj

	
func get_neighbors(pos: Vector2):
	var neighbor_above = Vector2i(pos.x, pos.y - 1)
	var neighbor_below = Vector2i(pos.x, pos.y + 1)
	var neighbor_left = Vector2i(pos.x - 1, pos.y)
	var neighbor_right = Vector2i(pos.x + 1, pos.y)
	return [
		get_cell_atlas_coords(0, neighbor_above),
		get_cell_atlas_coords(0, neighbor_below),
		get_cell_atlas_coords(0, neighbor_left),
		get_cell_atlas_coords(0, neighbor_right)
	]

func get_tile_type(pos: Vector2):
	if is_dirt_tile(pos):
		if is_upper_edge(pos):
			return DIRT_NORTH_EDGE
		elif is_lower_edge(pos):
			return DIRT_SOUTH_EDGE
		elif is_west_edge(pos):
			return DIRT_WEST_EDGE
		elif is_east_edge(pos):
			return DIRT_EAST_EDGE
		elif is_northwest_corner(pos):
			return DIRT_NORTH_WEST_CORNER
		elif is_southwest_corner(pos):
			return DIRT_SOUTH_WEST_CORNER
		elif is_northeast_corner(pos):
			return DIRT_NORTH_EAST_CORNER
		elif is_southeast_corner(pos):
			return DIRT_SOUTH_EAST_CORNER
		elif is_north_corner(pos):
			return DIRT_NORTH_CORNER
		elif is_south_corner(pos):
			return DIRT_SOUTH_CORNER
		elif is_west_corner(pos):
			return DIRT_WEST_CORNER
		elif is_east_corner(pos):
			return DIRT_EAST_CORNER
		elif is_tunnel_horiz(pos):
			return DIRT_TUNNEL_HORIZ
		elif is_tunnel_vert(pos):
			return DIRT_TUNNEL_VERT
		elif is_patch(pos):
			return DIRT_PATCH
		else:
			return Vector2i(0, 1)
	elif is_dark_grass_tile(pos):
		if is_upper_edge(pos):
			return DARK_GRASS_NORTH_EDGE
		elif is_lower_edge(pos):
			return DARK_GRASS_SOUTH_EDGE
		elif is_west_edge(pos):
			return DARK_GRASS_WEST_EDGE
		elif is_east_edge(pos):
			return DARK_GRASS_EAST_EDGE
		elif is_northwest_corner(pos):
			return DARK_GRASS_NORTH_WEST_CORNER
		elif is_southwest_corner(pos):
			return DARK_GRASS_SOUTH_WEST_CORNER
		elif is_northeast_corner(pos):
			return DARK_GRASS_NORTH_EAST_CORNER
		elif is_southeast_corner(pos):
			return DARK_GRASS_SOUTH_EAST_CORNER
		elif is_north_corner(pos):
			return DARK_GRASS_NORTH_CORNER
		elif is_south_corner(pos):
			return DARK_GRASS_SOUTH_CORNER
		elif is_west_corner(pos):
			return DARK_GRASS_WEST_CORNER
		elif is_east_corner(pos):
			return DARK_GRASS_EAST_CORNER
		elif is_tunnel_horiz(pos):
			return DARK_GRASS_TUNNEL_HORIZ
		elif is_tunnel_vert(pos):
			return DARK_GRASS_TUNNEL_VERT
		elif is_patch(pos):
			return DARK_GRASS_PATCH
		else:
			return Vector2i(0, 0)
	else:
		return Vector2i(0, 2)

func is_dirt_tile(tile_pos: Vector2):
	var cell_atlas_coords = get_cell_atlas_coords(0, tile_pos)
	return cell_atlas_coords.y == 1

func is_dark_grass_tile(tile_pos: Vector2):
	var cell_atlas_coords = get_cell_atlas_coords(0, tile_pos)
	return cell_atlas_coords.y == 0

func is_upper_edge(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_lower_edge(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_west_edge(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_east_edge(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_northwest_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_southwest_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_northeast_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_southeast_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_north_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_south_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_west_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_east_corner(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_tunnel_horiz(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y == curr_cell.y \
		and neighbors[3].y == curr_cell.y

func is_tunnel_vert(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y == curr_cell.y \
		and neighbors[1].y == curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y != curr_cell.y

func is_patch(pos: Vector2):
	var neighbors = get_neighbors(pos)
	var curr_cell = get_cell_atlas_coords(0, pos)
	return neighbors[0].y != curr_cell.y \
		and neighbors[1].y != curr_cell.y \
		and neighbors[2].y != curr_cell.y \
		and neighbors[3].y != curr_cell.y

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
				var tile_x = pos.x - (chunk_width / 2) + x
				var tile_y = pos.y - (chunk_width / 2) + y
				var key = str(tile_x) + "," + str(tile_y)

				# Clear out foliage
				if foliage_map.has(key):
					var foliage_obj = foliage_map[key]
					add_to_recycling_bin(foliage_obj)
					foliage_map.erase(key)

				# Clear out enemy spawner
				if enemy_spawner_map.has(key):
					var enemy_spawner = enemy_spawner_map[key]
					enemy_spawner.queue_free()
					enemy_spawner_map.erase(key)

				# Clear tile by setting to -1, -1
				set_cell(0, Vector2i(tile_x, tile_y), -1, Vector2(-1, -1))

func dist(p1, p2):
	var r = p1 - p2
	return sqrt(r.x ** 2 + r.y ** 2)

func add_to_recycling_bin(foliage_obj: Foliage):
	foliage_obj.visible = false
	match foliage_obj.foliage_type:
		Foliage.FoliageType.WEED:
			if !foliage_recycling_bin.has("WEED"):
				foliage_recycling_bin["WEED"] = []
			foliage_recycling_bin["WEED"].append(foliage_obj)
		Foliage.FoliageType.SHRUB:
			if !foliage_recycling_bin.has("SHRUB"):
				foliage_recycling_bin["SHRUB"] = []
			foliage_recycling_bin["SHRUB"].append(foliage_obj)
		Foliage.FoliageType.SMALL_TREE:
			if !foliage_recycling_bin.has("SMALL_TREE"):
				foliage_recycling_bin["SMALL_TREE"] = []
			foliage_recycling_bin["SMALL_TREE"].append(foliage_obj)
		Foliage.FoliageType.LARGE_TREE:
			if !foliage_recycling_bin.has("LARGE_TREE"):
				foliage_recycling_bin["LARGE_TREE"] = []
			foliage_recycling_bin["LARGE_TREE"].append(foliage_obj)
