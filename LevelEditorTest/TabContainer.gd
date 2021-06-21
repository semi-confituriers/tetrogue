extends TabContainer

onready var object_cursor = get_node("/root/main/Editor_Object")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TabContainer_mouse_entered():
	if object_cursor: 
		object_cursor.can_place = false
		object_cursor.hide()

func _on_TabContainer_mouse_exited():
	if object_cursor: 
		object_cursor.can_place = true
		object_cursor.show()
