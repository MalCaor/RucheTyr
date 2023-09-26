extends RigidBody2D

var list_tyr: Array[Node] = []
var hormagaunt = load("res://Tyr/hormagaunt.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in 10:
		add_tyr(hormagaunt, position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_tyr(tyr_to_add, pos):
	var new_tyr: Node = tyr_to_add.instantiate()
	new_tyr.transform.origin = pos
	list_tyr.append(new_tyr)
	add_child(new_tyr)
