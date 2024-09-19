extends StateMachine
@export var id = 1

func _ready():
	add_state('STAND')
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('CROUCH')
	add_state('AIR')
	add_state('LANDING')
	call_deferred("set_state", states.AIR)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.move_and_slide()
	
	parent.states.text = states.find_key(state)
	
	if Landing():
		parent.Frame()
		return states.STAND
	
	if Falling():
		parent.Frame()
		return states.AIR
	
	match state:
		states.STAND:
			if Input.get_action_strength("right_%s" % id) == 1:
				parent.velocity.x = parent.RUNSPEED
				parent.Frame()
				parent.turn(false)
				return states.DASH
				
			if Input.get_action_strength("left_%s" % id) == 1:
				parent.velocity.x = -parent.RUNSPEED
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
				
		states.JUMP_SQUAT:
			if parent.frame >= parent.JUMPSQUAT:
				if Input.is_action_pressed("jump_%s" % id):
					return states.FULL_HOP
				else:
					return states.SHORT_HOP
			
		states.SHORT_HOP:
			parent.velocity.y = parent.MIN_JUMPFORCE
			return states.AIR
			
		states.FULL_HOP:
			parent.velocity.y = parent.MAX_JUMPFORCE
			return states.AIR
			
		states.DASH:
			if Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.Frame()
				parent.velocity.x = -parent.DASHSPEED
			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent.Frame()
				parent.velocity.x =parent.DASHSPEED
			else:
				if parent.frame >= parent.dash_duration-1:
					return states.STAND
					
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.Frame()
				return states.JUMP_SQUAT
		states.MOONWALK:
			pass
		states.WALK:
			pass
		states.CROUCH:
			if not Input.is_action_pressed("down_%s" % 1):
				parent.Frame()
				return states.STAND
				
			if parent.velocity.x > 0 and state == states.CROUCH:
				parent.velocity.x += -parent.TRACTION*1.2
				parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
				
			elif parent.velocity.x < 0 and state == states.CROUCH:
				parent.velocity.x += parent.TRACTION*1.2
				parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
				
			if Input.is_action_pressed("jump_%s" % 1):
				parent.in_fastfall = true
				parent.Frame()
				return states.AIR
			
		states.AIR:
			air_movement()
		
		states.LANDING:
			pass

func air_movement():
	#gravidade
	if parent.velocity.y < parent.MAX_FALLSPEED:
		parent.velocity.y += parent.GRAVITY
		parent.velocity.y = clamp(parent.velocity.y, parent.velocity.y, parent.MAX_FALLSPEED)
	
	
		
	if Input.is_action_just_pressed("down_%s" % 1):
				parent.in_fastfall = true
				
	if not Input.is_action_pressed("down_%s" % 1):
				parent.in_fastfall = false
				
	if parent.in_fastfall:
		parent.velocity.y = parent.FASTFALL_SPEED
		parent.set_collision_mask_value(2,false)
		parent.Chao_L.set_collision_mask_value(2,false)
		parent.Chao_R.set_collision_mask_value(2,false)
		
	else:
		parent.set_collision_mask_value(2,true)
		parent.Chao_L.set_collision_mask_value(2,true)
		parent.Chao_R.set_collision_mask_value(2,true)
		
		
	#movimento horizontal
	if Input.is_action_pressed("left_%s" % 1) and parent.velocity.x > -parent.MAX_AIRSPEED:
		parent.velocity.x -= parent.AIR_ACCEL
		
	elif Input.is_action_pressed("right_%s" % 1) and parent.velocity.x < parent.MAX_AIRSPEED:
		parent.velocity.x += parent.AIR_ACCEL
	
	else:
		if parent.velocity.x > 0:
			parent.velocity.x -= parent.AIR_ACCEL/5
			parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
	
	
	
func Landing():
	if state_includes([states.AIR]):
		if parent.Chao_L.is_colliding() and parent.velocity.y >= 0:
			var collider = parent.Chao_L.get_collider()
			return true
		elif parent.Chao_R.is_colliding() and parent.velocity.y >= 0:
			var collider = parent.Chao_R.get_collider()
			return true
			
func Falling():
	if state_includes([states.STAND]):
		if not parent.Chao_L.is_colliding() and not parent.Chao_R.is_colliding():
			return true
		else:
			return false
