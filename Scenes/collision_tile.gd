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
	heal()
	empty_tile()
	
func process_heart_2(body: Node): 
	print("Took 2 hearts")
	heal()
	heal()
	empty_tile()
		
func process_exit(body: Node):
	print("Exit level")
	get_node("/root/Game").next_level()
	empty_tile()
	
func process_shield(body: Node):
	print("Picked up shield")
	hero.set_shield(true)
	empty_tile()
	
func process_sword(body: Node):
	print("Picked up sword")
	hero.set_sword(true)
	empty_tile()

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
