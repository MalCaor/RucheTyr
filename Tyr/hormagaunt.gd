extends RigidBody2D

enum state_possible{
	exploration
}
var current_state: state_possible

var speed: float = 1.0
var rotation_speed = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = state_possible.exploration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == state_possible.exploration:
		explore()

func explore():
	var rot = randf_range(-1, 1) * rotation_speed
	var dir = global_transform.x * speed
	apply_torque(rot)
	apply_impulse(dir)
