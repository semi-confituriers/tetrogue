extends Sprite

var speed : = 150.0
var path  : = PoolVector2Array() setget set_path

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func _process(delta:float) -> void: 
	var move_distance : = speed * delta
	move_along_path(move_distance)

func move_along_path(distance : float) -> void:
	var start_point = position
	var distance_to_next := 0 
	for i in range(path.size()): 
		distance_to_next = start_point.distance_to(path[0])
		if distance < distance_to_next and distance >= 0.0: 
			position = start_point.linear_interpolate(
				path[0], 
				distance / distance_to_next)
			break
		elif distance < 0: 
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
		
		

func set_path(value : PoolVector2Array) -> void: 
	path = value
	if value.size() == 0 : return
	set_process(true)

