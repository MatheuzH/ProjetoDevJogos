extends Area2D

var parent = get_parent()
@export var width = 300 
@export var height = 400 
@export var damage = 50 
@export var angle = 90 
@export var base_kb = 100 
@export var kb_scaling = 2 
@export var duration = 1500
@export var hitlag_modifier = 1
@export var type = "normal"
@export var angle_flipper = 0 
@onready var hitbox = get_node("Hitbox_Shape")
@onready var parentState = get_parent().selfState
var knockbackVal
var framez = 0.0 
var player_list = [] 

func set_parameters(w,h,d,a,b_kb,kb_s,dur,t,p,af,hit,parent=get_parent()):
	self.position = Vector2(0,0)
	player_list.append(parent)
	player_list.append(self)
	width = w 
	height = h 
	damage = d 
	angle = a 
	base_kb = b_kb
	kb_scaling = kb_s
	duration = dur
	type = t
	self.position = p
	hitlag_modifier = hit
	angle_flipper = af
	update_extents()
	connect("body_entered", Callable(self, "Hitbox_collide"))
	set_physics_process(true)

func Hitbox_collide(body):
	if ! (body in player_list):
		player_list.append(body)
		var charstate
		charstate = body.get_node("StateMachine")
		var weight = body.weight
		body.percentage += damage
		knockbackVal = knockback(body.percentage, damage, weight, kb_scaling, base_kb, 1)
		body.knockback = knockbackVal
		body.hitstun = floor(knockbackVal*0.1)
		get_parent().connected = true
		body.Frame()
		charstate.state = charstate.states.HITSTUN
		body.velocity.x = cos(deg_to_rad(angle))*knockbackVal
		body.velocity.y = -sin(deg_to_rad(angle))*knockbackVal

func knockback(percentage, damage, weight, kb_scaling, base_kb, ratio):
	return ((((percentage/10 + percentage*damage/20) * (200/(weight+100)*1.4) + 18)*kb_scaling) + base_kb)

func update_extents():
	hitbox.shape.extents = Vector2(width,height)

func _ready():
	hitbox.shape = RectangleShape2D.new()
	set_physics_process(false)
	pass

func _physics_process(delta):
	if framez<duration:
		framez += 1
	elif framez >= duration:
		Engine.time_scale = 1
		queue_free()
		return
	if get_parent().selfState != parentState:
		Engine.time_scale = 1
		queue_free()
		return 
