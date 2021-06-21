extends Node2D

var can_place = true
var is_panning = true
var _moveCamera: bool = false;
export var cam_speed = 10 

var maximum_zoom_in = 0.15
var minimum_zoom_out = 4
var zoom_sensitivity = 0.01
var mouse_start_pos
var screen_start_position

var dragging = false

onready var level = get_node("/root/main/Level")
onready var editor = get_node("/root/main/cam_container")
onready var editor_cam = editor.get_node('Camera2D')

var current_item
var itemName

func _ready():
	editor_cam.current = true
	
	var item_container  = get_node("/root/main/item_container")
	var pieceDescriptor = item_container.get_node('PieceDescriptor')
	var piecesObjects   = item_container.get_node('PiecesObjects')
	var itemTexture     = item_container.get_node('item_texture')
	var itemSelect      = get_node("/root/main/Item_select")
	var spritePieceDescriptor = pieceDescriptor.get_node('AnimatedSprite')
	
	var tetrisSpriteContainer = itemSelect.get_node('TabContainer/Tetris_Pieces/ScrollContainer/VBoxContainer/HBoxContainer')	
	var tilesContainer = itemSelect.get_node('TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer')
	
	var itemTile = item_container.get_node('item_tile') 
	var tileMap  = get_node('/root/main/Level/Navigation2D/TileMap')
	var tileSet  = tileMap.tile_set

	for anim_name in spritePieceDescriptor.frames.get_animation_names():
		var copy  = itemTexture.duplicate()
		copy.name = anim_name
		copy.texture = spritePieceDescriptor.frames.get_frame(anim_name, 0)
		tetrisSpriteContainer.add_child(copy)
	
	for cell_id in tileSet.get_tiles_ids(): 

		var atlas = AtlasTexture.new()
		atlas.atlas  =  tileSet.tile_get_texture(cell_id)
		atlas.region =  tileSet.tile_get_region(cell_id)

		var copy = itemTile.duplicate()
		copy.cell_name = cell_id
		copy.texture = atlas
		tilesContainer.add_child(copy)

func _process(delta):
	global_position = get_global_mouse_position()
	
	if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
		var new_item = current_item.instance()
		new_item.get_node('AnimatedSprite').set_animation(itemName)
		level.add_child(new_item)
		new_item.global_position = get_global_mouse_position()
	is_panning = Input.is_action_pressed("mb_middle")
	move_editor()

func move_editor():
	if Input.is_action_pressed("w"): 
		editor.global_position.y -= cam_speed
	if Input.is_action_pressed("s"): 
		editor.global_position.y += cam_speed
	if Input.is_action_pressed("a"): 
		editor.global_position.x -= cam_speed
	if Input.is_action_pressed("d"): 
		editor.global_position.x += cam_speed

var _previousPosition: Vector2 = Vector2(0, 0);

func _unhandled_input(event):
	
	# Handling Zoom/Dezoom using mouse wheel
	if event is InputEventMouseButton : 
		if event.is_pressed(): 
			if event.button_index == BUTTON_WHEEL_UP: 
				editor_cam.zoom -= Vector2(0.1, 0.1)
			elif event.button_index == BUTTON_WHEEL_DOWN: 
				editor_cam.zoom += Vector2(0.1, 0.1)
		if is_panning: 
			editor.global_position -= event.relative + editor_cam.zoom
	
	# Handling Zoom/Dezoom using trackpad
	if event is InputEventPanGesture:
		var zoom_amount = event.delta.y * zoom_sensitivity
		var new_zoom = editor_cam.zoom.y + zoom_amount
		if (new_zoom < maximum_zoom_in):
			new_zoom = maximum_zoom_in
		elif (new_zoom > minimum_zoom_out):
			new_zoom = minimum_zoom_out
		editor_cam.zoom = Vector2(new_zoom, new_zoom)

	# Handling dragging the camera
	if event is InputEventMouseButton:
		if (event.button_index == BUTTON_LEFT 
				and event.is_pressed()
				and current_item == null) : 
			mouse_start_pos = event.position
			screen_start_position = editor.position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		editor.position = editor_cam.zoom * (
			mouse_start_pos - event.position) + screen_start_position	

