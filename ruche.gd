extends RigidBody2D

var type = "Ruche"

var list_tyr: Array[Node] = []
var hormagaunt = load("res://Tyr/hormagaunt.tscn")
var quantite_nourriture=0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in 50:
		add_tyr(hormagaunt, position+Vector2(randf(), randf()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_tyr(tyr_to_add, pos: Vector2):
	var new_tyr: RigidBody2D = tyr_to_add.instantiate()
	new_tyr.transform.origin = pos
	new_tyr.ruche_mere = self
	list_tyr.append(new_tyr)
	add_child(new_tyr)

func give_Nour_to_Ruche(quantite:int):
	quantite_nourriture+=quantite
	print("quantite_nourriture de la Ruche = "+quantite_nourriture)
