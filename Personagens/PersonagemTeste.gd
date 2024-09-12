extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const FAST_FALL_VELOCITY = 200.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	#drop da plataforma
	if Input.is_action_just_pressed("ui_accept") and Input.is_action_pressed("ui_down"):
		var collision_info = move_and_collide(get_gravity() * delta, true)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.get_collision_layer_value(2) and is_on_floor():
				velocity.y = JUMP_VELOCITY
			elif collider.get_collision_layer_value(3) and is_on_floor():
				velocity.y = FAST_FALL_VELOCITY
		self.set_collision_mask_value(3, false)
		
		
		
			
	# Handle jump
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#cancela drop da plataforma
	if Input.is_action_just_released("ui_down"):
		set_collision_mask_value(3, true)
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
