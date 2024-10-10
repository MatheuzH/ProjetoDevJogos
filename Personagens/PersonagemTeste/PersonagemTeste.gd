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

#HitBoxes 
@export var hitbox: PackedScene
var selfState

@onready var states = $State
@onready var jogador = $Jogador
@onready var Chao_L:RayCast2D = get_node("Chao_L")
@onready var Chao_R:RayCast2D = get_node("Chao_R")
@onready var Ledge_Grab_F = get_node("Raycasts/Ledge_Grab_F")
@onready var Ledge_Grab_B = get_node("Raycasts/Ledge_Grab_B")

var in_fastfall = false
var frame = 0

func create_hitbox(width, height, damage, angle, base_kb, kb_scaling, duration, type, points, angle_flipper,hitlag=1):
	var hitbox_instance = hitbox.instance()
	self.add_child(hitbox_instance)
	if direction() == 1:
		hitbox_instance.set_parameters(width,height, damage,-angle+180,base_kb, kb_scaling, duration,type,points,angle_flipper,hitlag)
	else:
		var flip_x_points = Vector2(-points.x, points.y)
		hitbox_instance.set_parameters(width,height, damage,-angle+180,base_kb, kb_scaling, duration,type,flip_x_points,angle_flipper,hitlag)
	return hitbox_instance



func updateframes(delta):
	frame += 1

func direction():
	if Ledge_Grab_F.get_cast_to().x > 0: 
		return 1
	else: 
		return -1


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
	
#Tilt Attacks 
func DOWN_TILT():
	if frame == 5:
		create_hitbox(40,20,8,90,3,120,3,'normal',Vector2(64,32),0,1)
	if frame >=10:
		return true 
