extends Area2D


var draggable = true

var phantom = null
var dragOffset = null

signal dropped(pos)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY")
	pass

func _input_event(viewport, event, shape_idx):
	print("_input_event")
	if not draggable:
		return
	
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		print("LeftClick")
		if event.pressed and phantom == null:
			phantom = duplicate()
			dragOffset = event.position - position
		elif !event.pressed and phantom != null:
			emit_signal("dropped", event.position + dragOffset)
			phantom.queue_free()
			
	elif event is InputEventMouseMotion && phantom != null:
		position = event.position - dragOffset
