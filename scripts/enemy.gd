extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func area_entered(area: Area2D):
	print("area_entered ", area)
	
func area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int):
	print("area_shape_entered ", area)
	
func body_entered(body: Node):
	print("body_entered ", body)
	
func body_shape_entered(body_id: int, body: Node, body_shape: int, local_shape: int):
	print("body_shape_entered ", body)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
