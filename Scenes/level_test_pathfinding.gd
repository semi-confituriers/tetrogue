extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var triggerBase = $triggerBase
#tile_set

var trigger_tiles = [
	'heart',
	'heart2',
	'exit',
	'shield',
	'sword',
]

var trigger_position_list = []

func _ready():
	# Instanciate collision objects
	var tile_id := 0 
	for name in trigger_tiles: 
		tile_id = tile_set.find_tile_by_name(name)
		for cell_pos in get_used_cells_by_id(tile_id): 
			print('oh oui')
			print(cell_pos)
			var center = cell_pos + Vector2(0.5, 0.5)
			trigger_position_list.append(center)
	print(trigger_position_list)
