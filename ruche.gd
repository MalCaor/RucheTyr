extends RigidBody3D

# tyr existing
var listTyr: Array[Node] = []

# tyr types
var horma = load("res://hormagaunt.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_tyr(horma, position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_tyr(tyr_to_add, position):
	var new_tyr: Node = tyr_to_add.instantiate()
	new_tyr.transform.origin = position
	listTyr.append(new_tyr)
	add_child(new_tyr)
