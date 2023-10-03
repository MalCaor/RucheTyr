extends RigidBody2D

var type = "Hormagaunt"

var ruche_mere: RigidBody2D

var types_to_avoid = [
	"Hormagaunt",
	"Ruche"
]
var list_body_to_evade: Array[RigidBody2D] = []
var types_to_approach = [
	"Nourriture"
]
var list_body_to_approach: Array[RigidBody2D] = []

enum state_possible{
	exploration,
	return_ruche,
	zerg
}
var current_state: state_possible

var speed: float = 1.0
var rotation_speed = 10

var nbr_nour_max: float = 1
var nbr_current_nour: float = 0


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
	if current_state == state_possible.zerg:
		zerg_maneuver()

func stat_change():
	if self.nbr_current_nour == nbr_nour_max:
		self.current_state = state_possible.return_ruche
	elif self.list_body_to_approach:
		self.current_state = state_possible.zerg

func explore():
	var rot = randf_range(-1, 1) * rotation_speed
	var dir = global_transform.x * speed
	apply_torque(rot)
	apply_impulse(dir)
	
	evasion_maneuver()

func return_to_ruche(delta):
	var dx:float = ruche_mere.position.x - position.x
	var dy:float = ruche_mere.position.y - position.y
	
	var angle_to_ruche:Vector2 = Vector2(dx,dy).normalized()
	var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche)
	
	apply_torque_impulse(angle_self/2)
	apply_impulse(global_transform.x * speed)
	evasion_maneuver()

func _on_enter_vision(body: RigidBody2D):
	if body.type in types_to_avoid:
		list_body_to_evade.append(body)
	if body.type in types_to_approach:
		list_body_to_approach.append(body)
	
func _on_exit_vision(body):
	if body.type in types_to_avoid:
		list_body_to_evade.remove_at(list_body_to_evade.find(body))
	if body.type in types_to_approach:
		list_body_to_approach.remove_at(list_body_to_approach.find(body))

		
func evasion_maneuver():
	for body in list_body_to_evade:
		var dist_to_body = position.distance_to(body.position) / 10
		if self.global_transform.x.angle_to(body.global_position) > 0:
			apply_torque(dist_to_body*rotation_speed)
		else:
			apply_torque(-1* dist_to_body * rotation_speed)
		apply_impulse(global_transform.x * speed * 0.1)

func zerg_maneuver():
	# approch nour
	for body in list_body_to_approach:
		var dx:float = body.position.x - position.x
		var dy:float = body.position.y - position.y
		
		var angle_to_nour:Vector2 = Vector2(dx,dy).normalized()
		var angle_self:float = self.global_transform.x.angle_to(angle_to_nour)
		
		apply_torque_impulse(angle_self/2)
		apply_impulse(global_transform.x * speed)
	# chech if full
	if nbr_current_nour >= nbr_nour_max:
		current_state = state_possible.return_ruche
	if not list_body_to_approach:
		current_state = state_possible.exploration


func _on_collision(body):
	if body.type == "Nourriture":
		body.eaten()
		nbr_current_nour += 1
