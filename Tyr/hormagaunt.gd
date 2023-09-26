extends RigidBody2D

var type = "Hormagaunt"

var ruche_mere: RigidBody2D

var types_to_avoid = [
	"Hormagaunt",
	"Ruche"
]

enum state_possible{
	exploration,
	return_ruche
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
	stat_change()
	
	if current_state == state_possible.exploration:
		explore()
	if current_state == state_possible.return_ruche:
		return_to_ruche(delta)

func stat_change():
	if self.global_position.distance_to(ruche_mere.global_position) > 50:
		self.current_state = state_possible.return_ruche
	else:
		pass
		# self.current_state = state_possible.exploration

func explore():
	var rot = randf_range(-1, 1) * rotation_speed
	var dir = global_transform.x * speed
	apply_torque(rot)
	apply_impulse(dir)
	
	evasion_maneuver()

func return_to_ruche(delta):
	var dx:float = ruche_mere.position.x - position.x
	var dy:float = ruche_mere.position.y - position.y
	#var angle_2_ruche:float = atan2(dy,dx)

	#var rot = min((2 * PI) - abs(angle_2_ruche - transform.get_rotation()), abs(angle_2_ruche - transform.get_rotation()))
	#atan2(sin(angle_2_ruche-transform.get_rotation()), cos(angle_2_ruche-transform.get_rotation())) #angle_2_ruche #+ randf_range(-1, 1) * rotation_speed
	#var dir = global_transform.x * speed
	#apply_impulse( Vector2(dx,dy).normalized())
	
	var angle_to_ruche:Vector2 = Vector2(dx,dy).normalized()#.angle()
	var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche)
	apply_torque_impulse(angle_self/10.0) #rot # apply_torque(rot)
	
	#evasion_maneuver()
#	var angle = (ruche_mere.global_position - self.global_position).angle()
#	rotation = lerp_angle(self.rotation, angle, delta)
	apply_impulse(global_transform.x * speed)

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

