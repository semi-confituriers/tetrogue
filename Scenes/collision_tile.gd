extends Area2D

onready var level =  get_node('/root/Game/LevelCont/Level')
onready var hero  = level.get_node('Hero')
onready var  tilemap = level.get_node('MapNavigation/Map')

func heal():
	if level.hitpoints < level.maxHitpoint:
		print("set child ", level.maxHitpoint - level.hitpoints - 1)
		var sprite = level.heartsContainer.get_child(
			level.maxHitpoint - level.hitpoints - 1)
		sprite.texture = load("res://assets/heart_full.png")
		level.hitpoints += 1

func process_heart(body: Node):
	print("Took heart")
	hero.get_node("HeartGainSound").play()
	yield(get_tree().create_timer(0.2), "timeout")
	heal()
	empty_tile()
	
func process_heart2(body: Node):
	get_node('/root/Game').set_controls(false) 
	print("Took 2 hearts")
	hero.get_node("HeartGainSound").play()
	yield(get_tree().create_timer(0.2), "timeout")
	heal()
	yield(get_tree().create_timer(0.7), "timeout")
	hero.get_node("HeartGainSound").play()
	yield(get_tree().create_timer(0.2), "timeout")
	heal()
	empty_tile()
	get_node('/root/Game').set_controls(true) 
		
func process_exit(body: Node):
	get_node('/root/Game').set_controls(false) 
	print("Exit level")
	hero.get_node("HappySound").play()
	yield(get_tree().create_timer(1.0), "timeout")
	get_node("/root/Game").next_level()
	empty_tile()
	get_node('/root/Game').set_controls(true) 
	
func process_shield(body: Node):
	get_node('/root/Game').set_controls(false) 
	print("Picked up shield")
	hero.set_shield(true)
	hero.get_node("FoundSound").play()
	empty_tile()
	get_node('/root/Game').set_controls(true) 
	
func process_sword(body: Node):
	get_node('/root/Game').set_controls(false) 
	print("Picked up sword")
	hero.set_sword(true)
	empty_tile()
	hero.get_node("FoundSound").play()
	get_node('/root/Game').set_controls(true) 

func empty_tile():
	var tileMapPos = tilemap.world_to_map(position) + Vector2(0.5, 0.5)
	tilemap.set_cellv(tileMapPos, 15)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
