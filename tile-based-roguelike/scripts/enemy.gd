extends CharacterBody2D

@onready var tilemap = $"../TileMap"
var current_path: Array[Vector2i]

func _process(delta):
	if current_path.is_empty():
		return
		
	var target_position = tilemap.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, 2)
	
	if global_position == target_position:
		current_path.pop_front()
	
	
func _unhandled_input(event):
	var click_position = get_global_mouse_position()
	if event.is_action_pressed("move_to") && tilemap.is_point_walkable(click_position):
		current_path = tilemap.astar.get_id_path(
			tilemap.local_to_map(global_position),
			tilemap.local_to_map(click_position)
		).slice(1)
	print("Current path is: ", current_path)
