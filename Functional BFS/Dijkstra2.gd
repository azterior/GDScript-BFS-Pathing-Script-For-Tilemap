extends TileMap
# Main Author Nico
# Az Contributor and writer

# Tilemap Variables
var Grid = get_used_cells()
var Mouse_pos = Vector2.ZERO
var Weight1 = 1
onready var Heatmap = $Heatmap
# Dictionaries
var DictionaryBFS = {}
var DictionaryTile = {1: 1, 2: 4} 

# Leftclick to get Mouse_pos, reset dictionary then
# call BFS to mouse pos with a default distance of 0
func _process(_delta):
	if Input.is_action_just_pressed("Left_Click"):
		Mouse_pos = world_to_map(get_global_mouse_position())
		if Grid.has(Mouse_pos):
			DictionaryBFS = {}
			BFS(Mouse_pos, 0)

# current_cell is a cell coord in Vector2
# cell_value_from_prev is the last cells distance
func BFS(current_cell, cell_value_from_prev):
	# If cell is not on grid do not do anything
	if not Grid.has(current_cell):
		return
	# current_cell's distance == last_cells_distance + current cells movement cost
	var current_value = cell_value_from_prev + get_tile_weight(current_cell)
	# If cell is already in the DictionaryBFS see if has found a faster path, if so ammend
	if DictionaryBFS.has(current_cell):
		if (DictionaryBFS[current_cell]) > current_value:
			DictionaryBFS[current_cell] = current_value
			Heatmap.set_cell(current_cell.x, current_cell.y, current_value - 1)
	# Else add an entry for the cell
	else: 
		DictionaryBFS[current_cell] = current_value
		Heatmap.set_cell(current_cell.x, current_cell.y, current_value - 1)
	
	# optional slow for visualization
	# yield(get_tree().create_timer(0.5),"timeout")
	# Check if current_cell has valid neighbours in 4 directions, if so
	# call BFS(neighbour, current cells distance)
	if DictionaryBFS.has(current_cell - Vector2.RIGHT):
		if DictionaryBFS[current_cell - Vector2.RIGHT] > DictionaryBFS[current_cell]:
			BFS(current_cell - Vector2.RIGHT, current_value)
	else: BFS(current_cell - Vector2.RIGHT, current_value)
	if DictionaryBFS.has(current_cell - Vector2.LEFT):
		if DictionaryBFS[current_cell - Vector2.LEFT] > DictionaryBFS[current_cell]:
			BFS(current_cell - Vector2.LEFT, current_value)
	else: BFS(current_cell - Vector2.LEFT, current_value)
	if DictionaryBFS.has(current_cell - Vector2.UP):
		if DictionaryBFS[current_cell - Vector2.UP] > DictionaryBFS[current_cell]:
			BFS(current_cell - Vector2.UP, current_value)
	else: BFS(current_cell - Vector2.UP, current_value)
	if DictionaryBFS.has(current_cell - Vector2.DOWN):
		if DictionaryBFS[current_cell - Vector2.DOWN] > DictionaryBFS[current_cell]:
			BFS(current_cell - Vector2.DOWN, current_value)
	else: BFS(current_cell - Vector2.DOWN, current_value)

	# check all 4 sides, use value to check if dictionary entry is non-existant or lower call BFS into it

# searches DictionaryTile for the weight/movement cost of the respective tile
func get_tile_weight(cell_value):
	return(DictionaryTile[get_cellv(cell_value)])
