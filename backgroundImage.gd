extends MeshInstance2D

@export var couleur = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = couleur


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
