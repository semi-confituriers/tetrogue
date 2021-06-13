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

func step_on_enemy(body: Node):
	var level =  get_node('/root/Game/LevelCont/Level')
	var hero = level.get_node('Hero')
	level.hitpoints -= 1
	hero.moving = false
	yield(get_tree().create_timer(1.0), "timeout")
	if not hero.shield: 
		var sprite = level.heartsContainer.get_child(
			level.heartsContainer.get_child_count() - (level.hitpoints + 1))
		sprite.texture = load("res://assets/heart_empty.png")
	yield(get_tree().create_timer(1.0), "timeout")
	if hero.sword:
		var sprite = self.get_parent()
		sprite.get_parent().remove_child(sprite)
	if level.hitpoints <= 0:
		$GameOverOverlay.show()
	else: 
		hero.moving = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
