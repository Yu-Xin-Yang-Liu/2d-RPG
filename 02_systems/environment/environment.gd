class_name EcosystemEnvironment
extends Node2D

enum TerrainType {
	GRASS,
	WATER,
	FOREST,
	DESERT,
	MOUNTAIN
}

@export var map_width: int = 50
@export var map_height: int = 50
@export var tile_size: int = 32

var terrain_grid: Dictionary = {}

func _ready() -> void:
	_generate_terrain()

func _generate_terrain() -> void:
	for x in range(map_width):
		for y in range(map_height):
			var terrain: TerrainType = _determine_terrain(x, y)
			terrain_grid[Vector2i(x, y)] = terrain

func _determine_terrain(x: int, y: int) -> TerrainType:
	var noise_val: float = randf()
	
	if y < map_height * 0.2:
		return TerrainType.WATER
	elif y < map_height * 0.3:
		return TerrainType.FOREST
	elif y < map_height * 0.6:
		return TerrainType.GRASS
	elif y < map_height * 0.8:
		return TerrainType.DESERT
	else:
		return TerrainType.MOUNTAIN

func get_terrain_at(position: Vector2) -> TerrainType:
	var grid_pos: Vector2i = local_to_map(position)
	return terrain_grid.get(grid_pos, TerrainType.GRASS)

func local_to_map(local_pos: Vector2) -> Vector2i:
	return Vector2i(int(local_pos.x / tile_size), int(local_pos.y / tile_size))

func map_to_local(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size)

func is_walkable(position: Vector2) -> bool:
	var terrain: TerrainType = get_terrain_at(position)
	return terrain != TerrainType.WATER and terrain != TerrainType.MOUNTAIN

func get_terrain_color(terrain: TerrainType) -> Color:
	match terrain:
		TerrainType.GRASS:
			return Color(0.3, 0.8, 0.2)
		TerrainType.WATER:
			return Color(0.2, 0.4, 0.9)
		TerrainType.FOREST:
			return Color(0.1, 0.5, 0.15)
		TerrainType.DESERT:
			return Color(0.9, 0.8, 0.4)
		TerrainType.MOUNTAIN:
			return Color(0.5, 0.5, 0.5)
		_:
			return Color.WHITE
