extends ScrollContainer

onready var object_cursor = get_node("/root/main/Editor_Object")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('mouse_entered', self, 'mouse_enter')
	connect('mouse_exited', self, 'mouse_leave')
	pass # Replace with function body.

func mouse_enter() : 
	if object_cursor: 
		object_cursor.can_place = false
		object_cursor.hide()
	pass
	
func mouse_leave(): 
	if object_cursor: 
		object_cursor.can_place = true
		object_cursor.show()
