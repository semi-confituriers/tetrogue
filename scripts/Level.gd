extends Node2D


var mapTileMap: TileMap;
var piecesNode: Node2D;
var dragging: bool = false;
var draggedPiece: Sprite = null;
var draggedOffset: Vector2;
var draggedPhantom: Sprite;


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
	mapTileMap = $MapNavigation/Map
	piecesNode = $Pieces
	
	# Memorizing where trigger tiles are : 
	# filling trigger_position_dict
	for name in trigger_tiles: 
		var tile_id = mapTileMap.tile_set.find_tile_by_name(name)
		for cell_pos in mapTileMap.get_used_cells_by_id(tile_id): 
			var center = mapTileMap.map_to_world(cell_pos) + 0.5 * mapTileMap.cell_size
			trigger_position_dict[center] = {
				'func' : trigger_tiles[name],
				'available' : true
			}
	print("trigger_position_dict=", trigger_position_dict)
func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		var piecesRelPos = event.position - piecesNode.position
		var mapRelPos = event.position - mapTileMap.position
		if event.pressed && dragging == false:
			for piece in $Pieces.get_children():
				if piece is Sprite:
					var pieceRelPos = piecesRelPos - piece.position
					if piece.is_pixel_opaque(pieceRelPos):
						dragging = true
						draggedPiece = piece
						draggedPiece.modulate = Color(1, 1, 1, 0.5)
						draggedOffset = pieceRelPos
						draggedPhantom = piece.duplicate()
						add_child(draggedPhantom)
						draggedPhantom.position = event.position - draggedOffset
						break
		elif event.pressed == false && dragging == true:
				draggedPiece.modulate = Color(1, 1, 1, 1)
				if piecesRelPos.x >= 0:
					# Dropped in pieces section
					dragging = false
					draggedPhantom.queue_free()
					draggedPhantom = null
					
					draggedPiece.position = piecesRelPos - draggedOffset
				else:
					dragging = false
					draggedPhantom.queue_free()
					draggedPhantom = null
					
					var mapRelPosPiece = mapRelPos - draggedOffset
					
					var gridPos = mapRelPosPiece / mapTileMap.cell_size
					gridPos = Vector2(round(gridPos.x), round(gridPos.y))
					
					var mapRect = mapTileMap.get_used_rect()
					
					var canFit = true
					for filling in GetPieceFillings(draggedPiece):
						if mapTileMap.get_cellv(gridPos + filling) != -1 \
						or !mapRect.has_point(gridPos + filling):
							canFit = false
							break
					
					if canFit:
						draggedPiece.get_parent().remove_child(draggedPiece)
						mapTileMap.add_child(draggedPiece)
						draggedPiece.position = gridPos * mapTileMap.cell_size
						
						PlacePiece(draggedPiece, gridPos)
					else:
						pass
					
				
				
	elif event is InputEventMouseMotion && dragging:
		draggedPhantom.position = event.position - draggedOffset
		

func GetPieceFillings(piece: Sprite):
	var spriteRect = piece.get_rect()
	var width = round(spriteRect.size[0] / mapTileMap.cell_size.x)
	var height = round(spriteRect.size[1] / mapTileMap.cell_size.y)
	
	var ret = []
	for y in range(0, height):
		for x in range(0, width):
			var centerPixel = Vector2(
				(x + 0.5) * mapTileMap.cell_size.x,
				(y + 0.5) * mapTileMap.cell_size.y
			)
			if piece.is_pixel_opaque(centerPixel):
				ret.append(Vector2(x, y))

	return ret
	
func PlacePiece(piece: Sprite, gridPos: Vector2):
	for filling in GetPieceFillings(piece):
		mapTileMap.set_cellv(gridPos + filling, 16)
	mapTileMap.update_dirty_quadrants()
		
	for child in piece.get_children():
		if child is Sprite:
			var childTilePos = mapTileMap.world_to_map(child.position + piece.position)
			if child.name == "enemy":
#				var collObj = load("res://Scenes/collision_tile.tscn")
#				collObj.connect("body_entered", self, "step_on_enemy")
#				mapTileMap.add_child(collObj)
				child.get_node("CollisionTile").connect("body_entered", self, "step_on_enemy")
			else:
				print("Unknown object name " + child.name)
				
	OnPiecePlaced()

func step_on_enemy(body: Node):
	print("Stepped on enemy tile ", body)


func OnPiecePlaced(): 
	print("OnPiecePlaced")
	print("trigger_position_dict=", trigger_position_dict)
	for position in trigger_position_dict: 
		var data = trigger_position_dict[position]
		if not data.available: continue
		print(data)
		Navigation2D
		var new_path = $MapNavigation.get_simple_path(
			$Hero.global_position,
			position, true)
		print("aaaa")
		print("from ", position)
		print("to ", $Hero.global_position)
		
		var line = $Line2D.duplicate()
#		add_child(line)
#		line.points = PoolVector2Array([position, $Hero.global_position])
#		print("new_path ", new_path)
		if new_path.size() > 0 : 
			$Line2D.points = new_path
			$Hero.path = new_path
			trigger_position_dict[position]['available'] = false
			break
