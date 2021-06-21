extends TextureRect

#onready var object_cursor = get_node("/root/main/Editor_Object")
#onready var cursor_sprite = object_cursor.get_node("Sprite")
#var this_scene = preload("res://LevelEditorTest/Objects/PieceDescriptor.tscn")

var this_scene = null
var cell_name  = -1  

func _ready(): connect("gui_input",self,"_item_clicked")

func _item_clicked(event):
	if event is InputEvent:
		if event.is_action_pressed("mb_left"):
			pass
#			object_cursor.current_item = this_scene
#			object_cursor.itemName = name
#			cursor_sprite.texture  = texture

func _input(event): 
	pass
#	if (Input.is_action_pressed("escape") 
#			and object_cursor.current_item != null): 
#		object_cursor.current_item = null
#		cursor_sprite.texture = null
