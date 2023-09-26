extends RigidBody2D

var type = "Hormagaunt"

var ruche_mere: RigidBody2D

var types_to_avoid = [
	"Hormagaunt",
	"Ruche"
]

enum state_possible{
	exploration
}
var current_state: state_possible

var speed: float = 1.0
var rotation_speed = 10

var list_body_to_evade: Array[RigidBody2D] = []

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
	
	evasion_maneuver()


func _on_enter_vision(body: RigidBody2D):
	if body.type in types_to_avoid:
		list_body_to_evade.append(body)
	
func _on_exit_vision(body):
	list_body_to_evade.remove_at(list_body_to_evade.find(body))

		
func evasion_maneuver():
	for body in list_body_to_evade:
		if self.global_transform.x.angle_to(body.global_position) > 0:
			apply_torque(0.1 * rotation_speed)
		else:
			apply_torque(-0.1 * rotation_speed)
		apply_impulse(global_transform.x * speed * 0.1)

