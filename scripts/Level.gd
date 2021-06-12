extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mapTileMap: TileMap;
var piecesNode: Node2D;
var dragging = false;
var draggedPiece = null;
var draggedOffset;
var draggedPhantom;


# Called when the node enters the scene tree for the first time.
func _ready():
	mapTileMap = $Map
	piecesNode = $Pieces
	
func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		var piecesRelPos = event.position - piecesNode.position
		var mapRelPos = event.position - mapTileMap.position
		if event.pressed && dragging == false:
			for piece in $Pieces.get_children():
				if piece is Sprite:
					print("piece.position ", piece.position)
					print("piecesRelPos ", piecesRelPos)
					var pieceRelPos = piecesRelPos - piece.position
					print("pieceRelPos ", pieceRelPos)
					if piece.is_pixel_opaque(pieceRelPos):
						print("Opaque pixel at ", pieceRelPos)
						dragging = true
						draggedPiece = piece
						draggedPiece.modulate = Color(1, 1, 1, 0.5)
						draggedOffset = pieceRelPos
						draggedPhantom = piece.duplicate()
						add_child(draggedPhantom)
						draggedPhantom.position = event.position - draggedOffset
						break
		elif event.pressed == false && dragging == true:
				print("Dragging stopped at: ", event.position)
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
					
					var canFit = true
					for filling in GetPieceFillings(draggedPiece):
						if mapTileMap.get_cellv(gridPos + filling) != -1:
							canFit = false
							break
					
					if canFit:
						draggedPiece.get_parent().remove_child(draggedPiece)
						mapTileMap.add_child(draggedPiece)
						draggedPiece.position = gridPos * mapTileMap.cell_size
						
						for filling in GetPieceFillings(draggedPiece):
							mapTileMap.set_cellv(gridPos + filling, 16)
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
