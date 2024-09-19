extends CharacterBody2D



const dash_duration = 10
const JUMPSQUAT = 3
const RUNSPEED = 340
const DASHSPEED = 390
const WALKSPEED = 200
const GRAVITY = 80
const MIN_JUMPFORCE = -500
const MAX_JUMPFORCE = -800
const DOUBLEJUMPFORCE = 1000
const MAX_AIRSPEED = 300
const AIR_ACCEL = 25
const FALLSPEED = 60
const FASTFALL_SPEED = 900
const MAX_FALLSPEED = 900
const TRACTION = 40
const ROLL_DISTANCE = 350
const air_dodge_speed = 500
const UP_B_LAUNCHSPEED = 700



@onready var states = $State
@onready var Chao_L:RayCast2D = get_node("Raycasts/Chao_L")
@onready var Chao_R:RayCast2D = get_node("Raycasts/Chao_R")

var in_fastfall = false
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
	
	

	
	
