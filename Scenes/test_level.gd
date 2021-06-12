extends Node2D
onready var nav_2d  : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Sprite
onready var level_tilemap : TileMap = $level

func process_heart(): pass
func process_heart_2(): pass
func process_exit(): pass
func process_shield(): pass
func process_sword(): pass

var trigger_tiles = {
	'heart' : funcref(self, "process_heart"),
	'heart2' : funcref(self, "process_heart2"),
	'exit' : funcref(self, "process_exit"),
	'shield' : funcref(self, "process_shield"),
	'sword' : funcref(self, "process_sword"),
}

var trigger_position_dict = {}

func _ready():
	# Memorizing where trigger tiles are : 
	# filling trigger_position_dict
	var tile_id := 0 
	for name in trigger_tiles: 
		tile_id = level_tilemap.tile_set.find_tile_by_name(name)
		for cell_pos in level_tilemap.get_used_cells_by_id(tile_id): 
			print('oh oui')
			print(cell_pos)
			var center = cell_pos + Vector2(0.5, 0.5)
			trigger_position_dict[center] = {
				'func' : trigger_tiles[name],
				'available' : true
			}
	print(trigger_position_dict)

func _try_all_trigger(): 
	for position in trigger_position_dict: 
		var data = trigger_position_dict[position]
		if not data.available: continue
		var new_path := nav_2d.get_simple_path(
			character.global_position,
			position)
		if new_path.size() > 0 : 
			line_2d.points = new_path
			character.path = new_path
			break
