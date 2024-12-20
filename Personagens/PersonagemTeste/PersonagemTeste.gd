extends CharacterBody2D

@export var id:int

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

#double jump stuff
const DOUBLEJUMPFORCE = 700
var air_jumps:int = 0
const max_air_jumps:int = 1

#air mechanics
const GRAVITY = 50
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
@export var percentage = 0
@export var stocks = 3
@export var weight = 100

#HitStun
var hdecay
var vdecay
var knockback
var hitstun
var connected:bool

@onready var animation := $AnimatedSprite2D
@onready var states = $State
@onready var jogador = $Jogador
@onready var Chao_L:RayCast2D = get_node("Chao_L")
@onready var Chao_R:RayCast2D = get_node("Chao_R")
@onready var Ledge_Grab_F = get_node("Wall_Cling_F")
@onready var Ledge_Grab_B = get_node("Wall_Cling_B")
@onready var anim = $AnimatedSprite2D/AnimationPlayer

var in_fastfall = false
var frame = 0

func create_hitbox(width:int, height:int, damage:int, angle, base_kb, kb_scaling, duration:int, type:String, points:Vector2, angle_flipper,hitlag:int = 1):
	var hitbox_instance = hitbox.instantiate()
	self.add_child(hitbox_instance)
	if direction() == 1:
		hitbox_instance.set_parameters(width,height, damage,angle,base_kb, kb_scaling, duration,type,points,angle_flipper,hitlag)
	else:
		var flip_x_points = Vector2(-points.x, points.y)
		hitbox_instance.set_parameters(width,height, damage,-angle+180,base_kb, kb_scaling, duration,type,flip_x_points,angle_flipper,hitlag)
	return hitbox_instance



func updateframes(delta):
	frame += 1

func direction():
	if $AnimatedSprite2D.flip_h == false: 
		return 1
	else: 
		return -1


func turn(direction):
	$AnimatedSprite2D.set_flip_h(direction)

func play_animation(animation_name):
	anim.stop(true)
	anim.play(animation_name)

func Frame():
	frame = 0

func _physics_process(delta: float) -> void:
	$State.text = str(selfState) #mostra estado atual
	$Frames.text = str(frame) #mostra quantos frames passaram desde a ultima troca de estado
	$Damage.text = str(percentage)
	pass
	
func set_all_collision_mask_value(layer:int, value:bool):
	set_collision_mask_value(layer,value)
	Chao_L.set_collision_mask_value(layer,value)
	Chao_R.set_collision_mask_value(layer,value)
	
	
	
func reset_Jumps():
	air_jumps = max_air_jumps

#Air Attacks:
func UP_AIR():
	if frame == 3:
		create_hitbox(60, 28, 8, 90, 3, 120, 4 , 'normal', Vector2(6,-30), 0, 1)
	if frame > 14:
		return true
		
func FOWARD_AIR():
	if frame == 4:
		create_hitbox(43, 46, 8, 90, 3, 120, 5, 'normal', Vector2(50,23), 0, 1)
	if frame > 19:
		return true
		
func BACK_AIR():
	if frame == 6:
		create_hitbox(43, 54, 8, 90, 3, 120, 10 , 'normal', Vector2(-31,0), 0, 1)
	if frame > 27:
		return true
		
func DOWN_AIR():
	if frame == 9:
		create_hitbox(54, 46, 8, 90, 3, 120, 6, 'normal', Vector2(0,35), 0, 1)
	if frame > 25:
		return true
	
func NEUTRAL_AIR():
	if frame == 4:
		create_hitbox(68, 68, 8, 90, 3, 120, 15 , 'normal', Vector2(0,0), 0, 1)
	if frame >= 30:
		return true
		
#Ground Attacks 
func UP_TILT():
	if frame == 4:
		create_hitbox(28, 54, 12, 90, 14, 1, 3 , 'normal', Vector2(0,-50), 0, 1)
	if frame >=12:
		return true

func FOWARD_TILT():
	if frame == 6:
		create_hitbox(36, 60, 8, 90, 3, 5, 4 , 'normal', Vector2(14,-2), 0, 1)
	if frame < 15:
		velocity.x = 300 * direction()
	if frame > 10:
		velocity.x *= 0.8
	if frame >= 26:
		return true

func DOWN_TILT():
	if frame == 5:
		create_hitbox(52, 26, 8, 90, 30, 10, 7, 'normal', Vector2(50,23), 0, 1)
	if frame >=21:
		return true 
	return false

func FOWARD_STRONG():
	if frame == 12:
		create_hitbox(44, 44, 30, 10, 30, 20, 10 , 'normal', Vector2(40,1), 0, 1)
	if frame >= 41:
		return true
