extends TileMap

var floor_Y_pos
var floor_width_in_cells
var floor_width_in_global
var n_floor_pieces

export var floor_speed = 350
var distance_travelled = 0
var floor_pieces_placed = 0
var game_started = false

func _ready():
	n_floor_pieces = get_used_cells().size() -1
	floor_Y_pos = get_used_cells()[0].y
	floor_width_in_cells = get_used_cells()[1].x - get_used_cells()[0].x
	floor_width_in_global = floor_width_in_cells * 10

func _process(delta):
	move(delta)
	generate_floor()

func move(delta):
	position.x -= floor_speed * delta
	distance_travelled += floor_speed * delta * 1.3
	if game_started:
		floor_speed += 0.1

func generate_floor():
	var pieces_passed_by = round(distance_travelled / floor_width_in_global)
	var pieces_to_place = pieces_passed_by - floor_pieces_placed
	for i in range(pieces_to_place):
		set_cell(n_floor_pieces * floor_width_in_cells, floor_Y_pos, 1)
		n_floor_pieces += 1
		floor_pieces_placed += 1

