extends Node2D


var nour = load("res://Nourriture/nourriture.tscn")
var list_nour: Array[Node] = []

var nb_start_nour = 5

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(nb_start_nour):
		spawn_nour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+=delta
	if timer > 5:
		print("SPAWN")
		spawn_nour()
		timer = 0

func spawn_nour():
	var new_nour: RigidBody2D = nour.instantiate()
	var pos: Vector2 = Vector2(0,0)
	while (pos.x < 5 and pos.x > -5) and (pos.y < 5 and pos.y > -5):
		pos = Vector2(randf_range(-1,1), randf_range(-1,1)) * 100
	new_nour.transform.origin = pos
	list_nour.append(new_nour)
	add_child(new_nour)
