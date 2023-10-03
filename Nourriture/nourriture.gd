extends RigidBody2D

var type = "Nourriture"
var quantite: int = 5;
var couleur = Color.SEA_GREEN

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = couleur
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eaten():
	quantite -= 1;
	self.scale /= 2
	if quantite <= 0:
		self.queue_free()
