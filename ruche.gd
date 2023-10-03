extends RigidBody2D

var type = "Ruche"

var list_tyr: Array[Node] = []
var hormagaunt = load("res://Tyr/hormagaunt.tscn")
var food_quantity=0

var couleur = Color.VIOLET

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = couleur
	for x in 50:
		add_tyr(hormagaunt, position+Vector2(randf(), randf()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(food_quantity>=5):
		food_quantity-=5
		add_tyr(hormagaunt, position+Vector2(randf(), randf()))

func add_tyr(tyr_to_add, pos: Vector2):
	var new_tyr: RigidBody2D = tyr_to_add.instantiate()
	new_tyr.transform.origin = pos
	new_tyr.ruche_mere = self
	list_tyr.append(new_tyr)
	add_child(new_tyr)

func give_food_to_Ruche(quantite:int):
	food_quantity+=quantite
	print("food_quantity de la Ruche = %s" % food_quantity)
