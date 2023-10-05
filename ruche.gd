extends RigidBody2D

var type = "Ruche"

var list_tyr: Array[Node] = []
var hormagaunt = load("res://Tyr/hormagaunt.tscn")
var food_quantity=0

@export var couleur = Color.VIOLET

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = couleur
	for x in 20:
		add_tyr(hormagaunt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# creation de nouveaux agents
	if(food_quantity>=10):
		food_quantity-=5
		add_tyr(hormagaunt)
	if(food_quantity<=0):
		for t in list_tyr:
			t.queue_free()
		self.queue_free()

func add_tyr(tyr_to_add):
	var new_tyr: RigidBody2D = tyr_to_add.instantiate()
	new_tyr.ruche_mere = self
	list_tyr.append(new_tyr)
	add_child(new_tyr)

func give_food_to_Ruche(quantite:int):
	food_quantity+=quantite
	#print("food_quantity de la Ruche = %s" % food_quantity)
	
func get_food_of_Ruche(quantite:int):
	if(quantite >= food_quantity):
		food_quantity=0
		return food_quantity
	else:
		food_quantity-=quantite
		return quantite
	#print("food_quantity de la Ruche = %s" % food_quantity)
