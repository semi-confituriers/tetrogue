extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mapTileMap;
var piecesTileMap;
var dragging;
var draggedSprite;
var draggedTileID;
var draggedTileFrom;


# Called when the node enters the scene tree for the first time.
func _ready():
	mapTileMap = $Map
	piecesTileMap = $Pieces
	dragging = false
	draggedSprite = null
	draggedTileID = null
	draggedTileFrom = null

func _input(event):
	
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		var piecesRelPos = event.position - piecesTileMap.position
		if event.pressed:
			if piecesRelPos.x >= 0:
				var gridPos = piecesTileMap.world_to_map(piecesRelPos)
				var tileID = piecesTileMap.get_cellv(gridPos)
				if not dragging && tileID != -1:
					print("Dragging started at at: ", piecesRelPos, " tileID=", tileID)
					dragging = true
					draggedTileID = tileID
					draggedTileFrom = gridPos
					draggedSprite = Sprite.new()
					draggedSprite.texture = piecesTileMap.tile_set.tile_get_texture(tileID)
					draggedSprite.region_rect = piecesTileMap.tile_set.tile_get_region(tileID)
					draggedSprite.region_enabled = true
					add_child(draggedSprite);
		else:
			if dragging:
				print("Dragging stopped at: ", event.position)
				dragging = false
				draggedSprite.queue_free()
				draggedSprite = null
				
				if piecesRelPos.x >= 0:
					# Dropped in pieces section
					var gridPos = piecesTileMap.world_to_map(piecesRelPos)
					piecesTileMap.set_cell(draggedTileFrom.x, draggedTileFrom.y, -1)
					piecesTileMap.set_cell(gridPos.x, gridPos.y, draggedTileID)
				
				
	elif event is InputEventMouseMotion && dragging:
		draggedSprite.position = event.position
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
