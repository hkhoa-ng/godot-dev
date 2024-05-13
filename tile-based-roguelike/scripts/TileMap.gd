extends TileMap

var astar = AStarGrid2D.new()
var map_rect = Rect2i();

func _ready():
	var tilemap_size = get_used_rect().end - get_used_rect().position
	map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
	
	var tile_size = get_tileset().tile_size
	
	astar.region = map_rect
	astar.cell_size = tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	set_walls(tilemap_size)

func set_walls(tilemap_size):
	for x in tilemap_size.x:
		for y in tilemap_size.y:
			var coords = Vector2i(x, y)
			var tile_data = get_cell_tile_data(0, coords)
			if tile_data && tile_data.get_custom_data("type") == "wall":
				astar.set_point_solid(coords)
				print("This is a wall: ", coords)

func is_point_walkable(position):
	var map_position = local_to_map(position)
	if map_rect.has_point(map_position) && !astar.is_point_solid(map_position):
		return true
	return false
