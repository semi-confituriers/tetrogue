extends Node2D


var mapTileMap: TileMap;
var piecesNode: Node2D;
var dragging: bool = false;
var draggedPiece: Sprite = null;
var draggedOffset: Vector2;
var draggedPhantom: Sprite;
var heartsContainer: HBoxContainer;
var hitpoints: int;
var maxHitpoint: int = 3;


#func heal():
#	if hitpoints < maxHitpoint:
#		print("set child ", maxHitpoint - hitpoints - 1)
#		var sprite = heartsContainer.get_child(maxHitpoint - hitpoints - 1)
#		sprite.texture = load("res://assets/heart_full.png")
#		hitpoints += 1
#
#func process_heart(body: Node):
#	print("Took heart")
#	heal()
#
#func process_heart_2(body: Node): 
#	print("Took 2 hearts")
#	heal()
#	heal()
#
#func process_exit(body: Node):
#	print("Exit level")
#	get_node("/root/Game").next_level()
#
#func process_shield(body: Node):
#	print("Picked up shield")
#	$Hero.set_shield(true)
#func process_sword(body: Node):
#	print("Picked up sword")
#	$Hero.set_sword(true)

var trigger_tiles = {
	'heart' : "process_heart",
	'heart2' : "process_heart2",
	'exit' : "process_exit",
	'shield' : "process_shield",
	'sword' : "process_sword",
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
			if trigger_tiles[name] != null:
				var coll = load("res://Scenes/collision_tile.tscn").instance()
				mapTileMap.add_child(coll)
				coll.position = mapTileMap.map_to_world(cell_pos);
				coll.connect("body_entered", coll, trigger_tiles[name])
	
	$GameOverOverlay.hide()
	heartsContainer = $PanelsCont/LeftPanel/HeartsContainer
	for child in heartsContainer.get_children():
		heartsContainer.remove_child(child)
	hitpoints = maxHitpoint
	for i in range(0, hitpoints):
		var heart = TextureRect.new();
		heart.texture = load("res://assets/heart_full.png")
		heartsContainer.add_child(heart)
			
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
			if "enemy" in child.name:
				var collisionTile = child.get_node('CollisionTile')
				collisionTile.connect("body_entered", collisionTile, "step_on_enemy")
			else:
				print("Unknown object name " + child.name)
				
	OnPiecePlaced()

#func step_on_enemy(body: Node):
#	print("Stepped on enemy tile ", body)
#	hitpoints -= 1
#
#	$Hero.moving = false
#	yield(get_tree().create_timer(1.0), "timeout")
#	if not $Hero.shield: 
#		var sprite = heartsContainer.get_child(heartsContainer.get_child_count() - (hitpoints + 1))
#		sprite.texture = load("res://assets/heart_empty.png")
#	yield(get_tree().create_timer(1.0), "timeout")
#	if $Hero.sword:
#		var enemy = body
#		#enemy.get_parent().remove_child(enemy)
#	if hitpoints <= 0:
#		$GameOverOverlay.show()
#	else: 
#		$Hero.moving = true

func OnPiecePlaced(): 
	print("OnPiecePlaced")
	print("trigger_position_dict=", trigger_position_dict)
	for triggerPos in trigger_position_dict: 
		var data = trigger_position_dict[triggerPos]
		if not data.available: continue
		print(data)
		
		
		var new_path = $MapNavigation.get_simple_path(
			$Hero.position,
			triggerPos, true)
		if new_path.size() > 0:
			print("SET HERO DESTINATION ", triggerPos)
			$Hero.destination = triggerPos

#		var new_path = $MapNavigation.get_simple_path(
#			$Hero.global_position,
#			triggerPos, true)
#		print("aaaa")
#		print("from ", triggerPos)
#		print("to ", $Hero.global_position)
#
#		var line = $Line2D.duplicate()
##		add_child(line)
##		line.points = PoolVector2Array([triggerPos, $Hero.global_position])
##		print("new_path ", new_path)
#		if new_path.size() > 0 : 
#			$Line2D.points = new_path
#			$Hero.path = new_path
#			trigger_position_dict[triggerPos]['available'] = false
#			break
