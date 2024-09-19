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
	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.move_and_slide()
	parent.states.text = str(state)
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
				
			if Input.is_action_pressed("jump_%s" % id):
				parent.Frame()
				return states.JUMP_SQUAT
				
				
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
			parent.velocity.y = parent.JUMPFORCE
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
							
		states.MOONWALK:
			pass
		states.WALK:
			pass
		states.CROUCH:
			pass
		states.AIR:
			pass

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false
