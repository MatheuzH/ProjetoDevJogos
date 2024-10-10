extends StateMachine
@export var id:int

func _ready():
	add_state('STAND')
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('RUNNING')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('CROUCH')
	add_state('AIR')
	add_state('LANDING')
	add_state('GROUND_ATTACK')
	call_deferred("set_state", states.STAND)
	

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.states.text = states.find_key(state) #mostra estado atual do personagem
	
	parent.jogador.text = "J" + str(id)
	
	if parent.position.y > 500:  #impede o personagem de sumir se cair
		parent.position.y = -500
	
	if Landing(): #detecta se o personagem esta aterrizando independente de estado
		parent.in_fastfall = false
		parent.velocity.y = 0
		parent.Frame()
		return states.LANDING
	
	parent.move_and_slide() #move o personagem
	
	if Falling(): #detecta se o personagem esta caindo independente de estado
		parent.in_fastfall = false
		parent.Frame()
		return states.AIR
	
	if Input.is_action_just_pressed("attack" % id) && TILT() == true:
		parent.frame()
		return states.GROUND_ATTACK
	
	match state: #coracao da maquina de estados
		states.STAND: #parado
			if Input.is_action_pressed("modfier_%s" % id) and Input.is_action_just_pressed("right_%s" % id):
				parent.velocity.x = parent.WALK_SPEED
				parent.Frame()
				parent.turn(false)
				return states.WALK
				
			if Input.is_action_pressed("modfier_%s" % id) and Input.is_action_just_pressed("left_%s" % id):
				parent.velocity.x = -parent.WALK_SPEED
				parent.Frame()
				parent.turn(true)
				return states.WALK
				
			if Input.is_action_just_pressed("right_%s" % id):
				parent.velocity.x = parent.DASH_SPEED
				parent.Frame()
				parent.turn(false)
				return states.DASH
				
			if Input.is_action_just_pressed("left_%s" % id):
				parent.velocity.x = -parent.DASH_SPEED
				parent.Frame()
				parent.turn(true)
				return states.DASH
				
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.Frame()
				return states.JUMP_SQUAT
			
			if Input.is_action_pressed("down_%s" % id):
				parent.Frame()
				return states.CROUCH
				
			if parent.velocity.x > 0 and state == states.STAND:
				parent.velocity.x += -parent.TRACTION*1
				parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
				
			elif parent.velocity.x < 0 and state == states.STAND:
				parent.velocity.x += parent.TRACTION*1
				parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
				
		states.JUMP_SQUAT: #iniciando pulo
			if parent.frame >= parent.JUMPSQUAT:
				if Input.is_action_pressed("jump_%s" % id):
					return states.FULL_HOP
				else:
					return states.SHORT_HOP
			
		states.SHORT_HOP: #pulo baixo
			parent.velocity.y = parent.MIN_JUMPFORCE
			return states.AIR
			
		states.FULL_HOP: #pulo alto
			parent.velocity.y = parent.MAX_JUMPFORCE
			return states.AIR
			
		states.DASH: #boost inicial de velocidade
			if Input.is_action_just_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.turn(true)
					parent.Frame()
				parent.velocity.x = -parent.DASH_SPEED
			elif Input.is_action_just_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent.turn(false)
					parent.Frame()
				parent.velocity.x = parent.DASH_SPEED
			else:
				if parent.frame >= parent.dash_duration-1:
					parent.Frame()
					return states.RUNNING
					
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.Frame()
				if Input.is_action_pressed("down_%s" % id):
					parent.in_fastfall = true
					parent.set_all_collision_mask_value(3,false)
					parent.velocity.y = parent.FASTFALL_SPEED
					return states.AIR
				else:
					return states.JUMP_SQUAT
		
		states.RUNNING: #personagem correndo
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.Frame()
				if Input.is_action_pressed("down_%s" % id):
					parent.in_fastfall = true
					parent.set_all_collision_mask_value(3,false)
					parent.velocity.y = parent.FASTFALL_SPEED
					return states.AIR
				else:
					return states.JUMP_SQUAT
					
			if parent.velocity.x > 0: #indo para direita
				parent.turn(false)
				if Input.is_action_pressed("right_%s" % id):
					if Input.is_action_pressed("modfier_%s" % id):
						parent.Frame()
						parent.velocity.x = parent.WALK_SPEED
						return states.WALK
					else:
						parent.velocity.x = parent.RUN_SPEED
					
				if Input.is_action_just_pressed("left_%s" % id):
					if Input.is_action_pressed("modfier_%s" % id):
						parent.Frame()
						parent.velocity.x = -parent.WALK_SPEED
						return states.WALK
					parent.velocity.x = -parent.DASH_SPEED
					parent.Frame()
					parent.turn(true)
					return states.DASH
					
			if parent.velocity.x < 0: #indo para esquerda
				parent.turn(true)
				if Input.is_action_pressed("left_%s" % id):
					if Input.is_action_pressed("modfier_%s" % id):
						parent.Frame()
						parent.velocity.x = -parent.WALK_SPEED
						return states.WALK
					parent.velocity.x = -parent.RUN_SPEED
					
				if Input.is_action_just_pressed("right_%s" % id):
					if Input.is_action_pressed("modfier_%s" % id):
						parent.Frame()
						parent.velocity.x = parent.WALK_SPEED
						return states.WALK
					parent.velocity.x = parent.DASH_SPEED
					parent.Frame()
					parent.turn(false)
					return states.DASH
				
			if not Input.is_action_pressed("right_%s" % id) and not Input.is_action_pressed("left_%s" % id):
				return states.STAND
			
		states.MOONWALK:
			pass
		states.WALK: #personagem andando
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.Frame()
				if Input.is_action_pressed("down_%s" % id):
					parent.in_fastfall = true
					parent.set_all_collision_mask_value(3,false)
					parent.velocity.y = parent.FASTFALL_SPEED
					return states.AIR
				else:
					return states.JUMP_SQUAT
					
			if parent.velocity.x > 0: #indo para direita
				parent.turn(false)
				if Input.is_action_pressed("right_%s" % id):
					if not Input.is_action_pressed("modfier_%s" % id):
						parent.velocity.x = parent.RUN_SPEED
						parent.Frame()
						return states.RUNNING
					else:
						parent.velocity.x = parent.WALK_SPEED
					
				if Input.is_action_just_pressed("left_%s" % id):
					if not Input.is_action_pressed("modfier_%s" % id):
						parent.velocity.x = -parent.DASH_SPEED
						parent.Frame()
						parent.turn(true)
						return states.DASH
					else:
						parent.velocity.x = -parent.WALK_SPEED
					
			if parent.velocity.x < 0: #indo para esquerda
				parent.turn(true)
				if Input.is_action_pressed("left_%s" % id):
					if not Input.is_action_pressed("modfier_%s" % id):
						parent.velocity.x = -parent.RUN_SPEED
						parent.Frame()
						parent.turn(true)
						return states.RUNNING
					else:
						parent.velocity.x = -parent.WALK_SPEED
					
				if Input.is_action_just_pressed("right_%s" % id):
					if not Input.is_action_pressed("modfier_%s" % id):
						parent.velocity.x = parent.DASH_SPEED
						parent.Frame()
						parent.turn(false)
						return states.DASH
					else:
						parent.velocity.x = parent.WALK_SPEED
				
			if not Input.is_action_pressed("right_%s" % id) and not Input.is_action_pressed("left_%s" % id):
				return states.STAND
			
		states.CROUCH: #personagem agachado
			if not Input.is_action_pressed("down_%s" % id):
				parent.Frame()
				return states.STAND
				
			if parent.velocity.x > 0 and state == states.CROUCH:
				parent.velocity.x += -parent.TRACTION*1.2
				parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
				
			elif parent.velocity.x < 0 and state == states.CROUCH:
				parent.velocity.x += parent.TRACTION*1.2
				parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
				
			if Input.is_action_pressed("jump_%s" % id):
				parent.in_fastfall = true
				parent.set_all_collision_mask_value(3,false)
				parent.Frame()
				parent.velocity.y = parent.FASTFALL_SPEED
				return states.AIR
			
		states.AIR: #no ar
			air_movement()
		
		states.LANDING: #pousando
			if parent.frame >= parent.LANDING_FRAMES + parent.landing_lag:
				parent.Frame()
				
				if Input.is_action_pressed("right_%s" % id):
					parent.velocity.x = parent.RUN_SPEED
					parent.turn(false)
					return states.RUNNING
					
				if Input.is_action_pressed("left_%s" % id):
					parent.velocity.x = -parent.RUN_SPEED
					parent.turn(true)
					return states.RUNNING
					
				return states.STAND


func TILT():
	if state_includes([states.STAND,states.MOONWALK,states.DASH,states.RUN,states.WALK,states.CROUCH]):
		return true

func air_movement():
	#gravidade
	if parent.velocity.y < parent.MAX_FALLSPEED:
		parent.velocity.y += parent.GRAVITY
		parent.velocity.y = min(parent.velocity.y, parent.MAX_FALLSPEED)
	
	
		
	if Input.is_action_just_pressed("down_%s" % id):
		parent.velocity.y = parent.FASTFALL_SPEED
		parent.in_fastfall = true
		parent.set_collision_mask_value(3,false)
		parent.Chao_L.set_collision_mask_value(3,false)
		parent.Chao_R.set_collision_mask_value(3,false)
		
	if not Input.is_action_pressed("down_%s" % id):
		parent.set_collision_mask_value(3,true)
		parent.Chao_L.set_collision_mask_value(3,true)
		parent.Chao_R.set_collision_mask_value(3,true)
		
	
		
		
	#movimento horizontal
	if Input.is_action_pressed("left_%s" % id) and parent.velocity.x > -parent.MAX_AIRSPEED:
		parent.velocity.x -= parent.AIR_ACCEL
		
	elif Input.is_action_pressed("right_%s" % id) and parent.velocity.x < parent.MAX_AIRSPEED:
		parent.velocity.x += parent.AIR_ACCEL
	
	elif not Input.is_action_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
		if parent.velocity.x > 0:
			parent.velocity.x -= parent.AIR_ACCEL/5
			parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
		if parent.velocity.x < 0:
			parent.velocity.x += parent.AIR_ACCEL/5
			parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
	
	
	
func Landing():
	if state_includes([states.AIR]):
		if parent.Chao_L.is_colliding() and parent.velocity.y > 0:
			var collider = parent.Chao_L.get_collider()
			return true
		elif parent.Chao_R.is_colliding() and parent.velocity.y > 0:
			var collider = parent.Chao_R.get_collider()
			return true
		else: 
			return false
func Falling():
	if state_includes([states.STAND, states.DASH, states.RUNNING]):
		if not parent.Chao_L.is_colliding() and not parent.Chao_R.is_colliding():
			return true
