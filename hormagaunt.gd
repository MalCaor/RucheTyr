extends RigidBody3D

var speed: float = 1.0

enum state_possible{
	exploration
}
var state = state_possible.exploration

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == state_possible.exploration:
		exploration()

func exploration():
	apply_impulse(Vector3(speed, 0, 0))
