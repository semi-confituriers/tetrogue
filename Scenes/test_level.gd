extends Node2D
onready var nav_2d  : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Sprite

func _unhandled_input(event: InputEvent) -> void :
	
	if not event is InputEventMouseButton: return 
	if not event.button_index == BUTTON_LEFT : return 
	
	var new_path : = nav_2d.get_simple_path(
		character.global_position,
		event.global_position)

	line_2d.points = new_path
	character.path = new_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _try_target(position:Vector2) -> void : 
	
	var new_path : = nav_2d.get_simple_path(
		character.global_position,
		position)
	
	# if path a des points : on continue
	# regardez aussi si pas d2j0 trigger
	# enfin, bougez le joueur
	
	line_2d.points = new_path
	character.path = new_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
