extends CharacterBody2D


const SPEED = 150
const JUMP_VELOCITY = -300.0
const DASHSPEED = 1000
const DASH_DURATION=0.2
const DASH_COOLDOWN= 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var dashtimer = $Timer

var is_dashing = false
var dash_time = 0.0

func _ready():
	dashtimer.wait_time = DASH_COOLDOWN
	dashtimer.one_shot = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.play("fall")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move left", "move right")
	var isdash = Input.is_action_just_pressed("dash")
			
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
	
