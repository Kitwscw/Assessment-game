extends CharacterBody2D


const SPEED = 150
const JUMP_VELOCITY = -300.0
const DASHSPEED = 1000
const DASH_DURATION=0.2
const DASH_COOLDOWN= 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980
@onready var sprite = $AnimatedSprite2D
@onready var dashtimer = $Timer

var dash_allow = false
var dash_active = false
var dash_time = 0.0
var jump_num=2

func _ready():
	dashtimer.wait_time = DASH_COOLDOWN
	dashtimer.one_shot = true

func _physics_process(delta):
	if is_on_floor():
		jump_num=2
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.play("fall")
	# Handle jump.
	if Input.is_action_just_pressed("jump")  and jump_num>0:
		velocity.y = JUMP_VELOCITY
		jump_num = jump_num-1
	var direction = Input.get_axis("move left", "move right")
	var dash_direction = Input.get_axis("move left", "move right")
	
	# Dash logic
	
	if Input.is_action_just_pressed("dash"):
		dash_allow=true
	print ("Can dash:", dash_active)
	if dash_allow == true and not dash_active and dashtimer.is_stopped():
		dash_active = true
		dash_direction = Vector2(direction, 1).normalized()
		velocity.x = dash_direction.x * DASHSPEED
		dash_time = DASH_DURATION
		dashtimer.start()
	
	if dash_active:
		dash_time = dash_time - delta
		if dash_time <= 0:
			dash_active = false
			velocity.x = direction * SPEED
			dash_allow=false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
			
	if direction<0:
		sprite.flip_h = true
		sprite.play("run")
	elif direction>0:
		sprite.flip_h = false
		sprite.play("run")
	else:
		sprite.play("idle")
	if direction:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward( velocity.x, 0, SPEED)
	elif not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 2.5)
	move_and_slide()
	
