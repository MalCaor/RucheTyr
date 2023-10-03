extends RigidBody2D

var type = "Hormagaunt"

var ruche_mere: RigidBody2D

var list_body_to_evade: Array[RigidBody2D] = [] # liste des body à éviter 
var types_to_avoid = [
	"Hormagaunt",
	"Ruche"
]

var list_body_to_approach: Array[RigidBody2D] = [] # liste des body à approcher 
var types_to_approach = [
	"Nourriture"
]

enum state_possible{ # Etat possible pour un agent: definie ses actions
	exploration,
	return_ruche,
	zerg
}

var current_state: state_possible # Etat actuel de l'agent: defini l'action que l'agent effectue

var speed: float = 3 # Vitesse de l'agent
var rotation_speed = 10 # Vitesse de rotation de l'agent

var nbr_nour_max: float = 5 # Quantite maximale qu'un agent peut transporter
var nbr_current_nour: float = 0 # Quantite actuelle que transporte un agent

var couleur: Color


# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = state_possible.exploration
	couleur = ruche_mere.couleur.darkened(0.5)
	self.modulate = couleur


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_change()
	
	if current_state == state_possible.exploration:
		explore()
	if current_state == state_possible.return_ruche:
		return_to_ruche(delta)
	if current_state == state_possible.zerg:
		zerg_maneuver()

func state_change():
	if self.nbr_current_nour >= nbr_nour_max && self.nbr_current_nour!=0:
		self.current_state = state_possible.return_ruche
	elif self.list_body_to_approach:
		self.current_state = state_possible.zerg
	else:
		self.current_state = state_possible.exploration

func explore():
	var rot = randf_range(-1, 1) * rotation_speed
	var dir = global_transform.x * speed
	apply_torque(rot)
	evasion_maneuver()
	go_forward()

func return_to_ruche(delta):
	var dx:float = ruche_mere.position.x - position.x
	var dy:float = ruche_mere.position.y - position.y
	
	var angle_to_ruche:Vector2 = Vector2(dx,dy).normalized()
	var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche)
	
	apply_torque_impulse(angle_self/2)
	evasion_maneuver()
	go_forward()

		
func evasion_maneuver():
	for body in list_body_to_evade:
		# puissance to evade 
		var dist = max(position.distance_to(body.position), 1)
		var puissance = 1 / dist
		
		# evasion vector
		var target_vect = global_position.direction_to(body.global_position)
		var angle = -1 * self.global_transform.x.angle_to(target_vect)
		
		# apply manu
		apply_torque(puissance*angle)

func zerg_maneuver():
	# approch nour
	if list_body_to_approach:
		var body = list_body_to_approach[0]
		var dx:float = body.position.x - position.x
		var dy:float = body.position.y - position.y
		
		var angle_to_nour:Vector2 = Vector2(dx,dy).normalized()
		var angle_self:float = self.global_transform.x.angle_to(angle_to_nour)
		
		apply_torque_impulse(angle_self/2)
		go_forward()
	
	evasion_maneuver()

func go_forward():
	apply_impulse(global_transform.x * speed)
	
func _on_collision(body):
	if body.type == "Nourriture":
		body.eaten()
		nbr_current_nour += 1
		self.modulate = Color.RED
	if body.type == "Ruche" && nbr_current_nour>0:
		ruche_mere.give_Nour_to_Ruche(nbr_current_nour)
		nbr_current_nour=0
		self.modulate = couleur
		var dx:float = ruche_mere.position.x - position.x
		var dy:float = ruche_mere.position.y - position.y
		
		var angle_to_ruche:Vector2 = -Vector2(dx,dy).normalized()
		var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche)
		apply_torque_impulse(angle_self)


func _on_enter_vision_collision(body):
	if body.type in types_to_avoid:
		list_body_to_evade.append(body)


func _on_exit_vision_collision(body):
	if body.type in types_to_avoid:
		list_body_to_evade.remove_at(list_body_to_evade.find(body))


func _on_entered_vision_nour(body):
	if body.type in types_to_approach:
		list_body_to_approach.append(body)


func _on_exited_vision_nour(body):
	if body.type in types_to_approach:
		list_body_to_approach.remove_at(list_body_to_approach.find(body))
