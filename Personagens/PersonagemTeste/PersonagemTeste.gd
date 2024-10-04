extends CharacterBody2D

#ground movement
const RUN_SPEED = 350
const DASH_SPEED = 450
const WALK_SPEED = 100
const dash_duration = 10
const TRACTION = 30
const ROLL_DISTANCE = 350

#jump mechanics
const JUMPSQUAT = 3
const MIN_JUMPFORCE = -500
const MAX_JUMPFORCE = -800

#air mechanics
const GRAVITY = 50
const DOUBLEJUMPFORCE = 1000
const MAX_AIRSPEED = 300
const AIR_ACCEL = 25
const FALLSPEED = 60
const FASTFALL_SPEED = 900
const MAX_FALLSPEED = 900
const air_dodge_speed = 500
const UP_B_LAUNCHSPEED = 700

#landing mechanics
const LANDING_FRAMES = 3
var landing_lag = 0


@onready var states = $State
@onready var jogador = $Jogador
@onready var Chao_L:RayCast2D = get_node("Chao_L")
@onready var Chao_R:RayCast2D = get_node("Chao_R")

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
	$AnimatedSprite2D.set_flip_h(direction)

func Frame():
	frame = 0



func _physics_process(delta: float) -> void:
	$Frames.text = str(frame) #mostra quantos frames passaram desde a ultima troca de estado
	pass
	
func set_all_collision_mask_value(layer:int, value:bool):
	set_collision_mask_value(layer,value)
	Chao_L.set_collision_mask_value(layer,value)
	Chao_R.set_collision_mask_value(layer,value)
	
	
	
	
