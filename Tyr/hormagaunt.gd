extends RigidBody2D

var type = "Hormagaunt"

var ruche_mere: RigidBody2D

var list_body_to_evade: Array[RigidBody2D] = [] # liste des body à éviter 

var tyranids = [
	"Hormagaunt"
]

var ruches = [
	"Ruche"
]

var types_to_avoid = [
	"Border"
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

var nbr_food_max: float = 2 # Quantite maximale qu'un agent peut transporter
var nbr_current_food: float = 0 # Quantite actuelle que transporte un agent

#var target_explore: Vector2
var timer_since_last_generation = 0

var interest_point: Vector2
var generated_interest_point : bool = true

var couleur: Color

var ligne_dest: Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = state_possible.exploration
	couleur = ruche_mere.couleur
	self.modulate = couleur


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_change()
	if ligne_dest:
		ligne_dest.queue_free()
		ligne_dest = null
	
	if current_state == state_possible.exploration:
		explore()
	elif current_state == state_possible.return_ruche:
		return_to_ruche(delta)
	elif current_state == state_possible.zerg:
		zerg_maneuver()

### BEHAVIOUR FUNCTION ###

func state_change():
	if self.nbr_current_food >= nbr_food_max && self.nbr_current_food!=0:
		self.current_state = state_possible.return_ruche
		self.modulate = self.couleur.darkened(0.2)
	elif self.list_body_to_approach:
		self.current_state = state_possible.zerg
		self.modulate = self.couleur
	else:
		self.current_state = state_possible.exploration
		self.modulate = self.couleur.lightened(0.5)

func generate_coor():
	return Vector2(randf_range(-1,1)* 100, randf_range(-1,1)* 100)
	
func draw_ligne_to_target(target: Vector2):
	ligne_dest = Line2D.new()
	ligne_dest.add_point(Vector2(0,0), 0)
	ligne_dest.add_point(to_local(target), 1)
	ligne_dest.width = 0.3
	add_child(ligne_dest)
	

func explore():
	# generate target
	if (self.position.distance_to(interest_point) < 20 or timer_since_last_generation > 1000):
		interest_point = generate_coor()
		timer_since_last_generation = 0
		self.generated_interest_point = true

	timer_since_last_generation += 1
	
	# travel calculation
	draw_ligne_to_target(interest_point)
	var angle_self = angle_to_target(interest_point)
	
	# apply navigation
	apply_torque_impulse(angle_self/2)
	
	evasion_maneuver()
	go_forward()

func return_to_ruche(delta):
	var angle_self = angle_to_target(ruche_mere.position)
	
	apply_torque_impulse(angle_self/2)
	go_forward()

		
func evasion_maneuver():
	for body in list_body_to_evade:
		var angle_self = angle_to_target(body.position)
		apply_torque_impulse((angle_self/50) * -1)

func zerg_maneuver():
	# approch nour
	if list_body_to_approach:
		# Select first target
		var body = list_body_to_approach[0]
		
		# draw line to target
		draw_ligne_to_target(body.global_position)
		
		# go toward target
		var angle_self = angle_to_target(body.global_position)
		apply_torque_impulse(angle_self/2)
		go_forward()
	elif not self.generated_interest_point:
		# draw line to intrest point
		draw_ligne_to_target(self.interest_point)
		
		# go to target
		var angle_self = angle_to_target(self.interest_point)
		apply_torque_impulse(angle_self/2)
		go_forward()
		
	
	#evasion_maneuver()

func go_forward():
	apply_impulse(global_transform.x * speed)
	
	
### UTILITY FUNCTION ###

func angle_to_target(vector_target: Vector2):
	var dx:float = vector_target.x - global_position.x
	var dy:float = vector_target.y - global_position.y
	
	var angle_to_nour:Vector2 = Vector2(dx,dy).normalized()
	var angle_self:float = self.global_transform.x.angle_to(angle_to_nour)
	return angle_self

### TRIGGER FUNCTION ###
	
func _on_collision(body):
	if body.type == "Nourriture":
		#interest_point = body.position
		body.eaten()
		nbr_current_food += 1
		#self.modulate = Color.RED
	if body.type == "Ruche" && body == self.ruche_mere:
		if nbr_current_food>0:
			ruche_mere.give_food_to_Ruche(nbr_current_food)
			nbr_current_food=0
			#self.modulate = couleur
		
		var dx:float = ruche_mere.position.x - position.x
		var dy:float = ruche_mere.position.y - position.y
		var angle_to_ruche:Vector2 = Vector2(dx,dy).normalized()
		var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche*-1)
		apply_torque_impulse(angle_self*10)
		self.look_at(-angle_to_ruche)
		go_forward()
	if body.type == "Ruche" && body != self.ruche_mere:
		interest_point = body.position
		self.generated_interest_point = false
		if nbr_current_food<nbr_food_max:
			nbr_current_food = body.get_food_of_Ruche(nbr_food_max - nbr_current_food)
		
		var dx:float = ruche_mere.position.x - position.x
		var dy:float = ruche_mere.position.y - position.y
		var angle_to_ruche:Vector2 = Vector2(dx,dy).normalized()
		var angle_self:float = self.global_transform.x.angle_to(angle_to_ruche*-1)
		apply_torque_impulse(angle_self*10)
		self.look_at(-angle_to_ruche)
		go_forward()
	if body.type in tyranids && body.ruche_mere != self.ruche_mere:
		# sur du 4+
		if randi_range(0,6)>=4:
			body.queue_free()


func _on_enter_vision_collision(body):
	if body.type in tyranids:
		if body.ruche_mere != self.ruche_mere:
			pass
			#list_body_to_approach.append(body)
		else:
			list_body_to_evade.append(body)
			body.interest_point = interest_point
			body.generated_interest_point = false
	if body.type in types_to_avoid:
		list_body_to_evade.append(body)


func _on_exit_vision_collision(body):
	if body in list_body_to_evade:
		list_body_to_evade.remove_at(list_body_to_evade.find(body))
	if body in list_body_to_approach:
		list_body_to_approach.remove_at(list_body_to_approach.find(body))


func _on_entered_vision_nour(body):
	if body.type in tyranids:
		if body.ruche_mere != self.ruche_mere:
			list_body_to_approach.append(body)
	if body.type in ruches:
		if body != self.ruche_mere:
			list_body_to_approach.append(body)
	if body.type in types_to_approach:
		list_body_to_approach.append(body)


func _on_exited_vision_nour(body):
	if body in list_body_to_approach:
		list_body_to_approach.remove_at(list_body_to_approach.find(body))
	if body in list_body_to_evade:
		list_body_to_evade.remove_at(list_body_to_evade.find(body))

func _exit_tree():
	print("Hormagaunt POP")
	self.ruche_mere.list_tyr.remove_at(self.ruche_mere.list_tyr.find(self))
