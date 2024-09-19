extends CharacterBody2D



const dash_duration = 10
const JUMPSQUAT = 3
const RUNSPEED = 340
const DASHSPEED = 390
const WALKSPEED = 200
const GRAVITY = 1800
const JUMPFORCE = -500
const MAX_JUMPFORCE = -800
const DOUBLEJUMPFORCE = 1000
const MAXAIRSPEED = 300
const AIR_ACCEL = 25
const FALLSPEED = 60
const FALLINGSPEED = 900
const MAXFALLSPEED = 900
const TRACTION = 40
const ROLL_DISTANCE = 350
const air_dodge_speed = 500
const UP_B_LAUNCHSPEED = 700

const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const FAST_FALL_VELOCITY = 200.0

@onready var states = $State

var frame = 0

func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)

func Frame():
	frame = 0



func _physics_process(delta: float) -> void:
	$Frames.text = str(frame)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	
