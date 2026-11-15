extends CharacterBody2D

# MOVEMENT SETTINGS
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1000.0

# GRAVITY
var gravity = 980.0

# RESPAWN SETTINGS
@export var respawn_position: Vector2 = Vector2(46,-94) # Change this to your safe starting X and Y
@export var fall_limit_y: float = 500.0                 # Y-level where Douglas dies and resets

# PLAYER ANIMATION
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:

	# APPLY GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta

	# JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("jump")
		velocity.y = JUMP_VELOCITY

	# GET MOVEMENT INPUT
	var direction = Input.get_axis(
		"move_left",
		"move_right"
	)

	# MOVE LEFT AND RIGHT
	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			ACCELERATION * delta
		)

		# TURN CHARACTER
		animated_sprite.flip_h = direction < 0

	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			ACCELERATION * delta
		)
	if Input.is_action_just_pressed("move_left"):
		print("LEFT PRESSED")

	if Input.is_action_just_pressed("move_right"):
		print("RIGHT PRESSED")

	if Input.is_action_just_pressed("jump"):
		print("JUMP PRESSED")

	# APPLY MOVEMENT
	move_and_slide()

	# PLAY ANIMATIONS
	update_animation()

	# CHECK IF DOUGLAS FELL OFF THE WORLD
	if global_position.y > fall_limit_y:
		respawn_player()


func respawn_player() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO # Stop all movement so he doesn't keep falling fast


func update_animation() -> void:

	# JUMPING ANIMATION
	if velocity.y < 0 and not is_on_floor():
		play_animation("jump")

	# FALLING ANIMATION
	elif velocity.y > 0 and not is_on_floor():
		play_animation("fall")

	# RUNNING ANIMATION
	elif abs(velocity.x) > 10:
		play_animation("run")

	# IDLE ANIMATION
	else:
		play_animation("idle")


func play_animation(animation_name: String) -> void:

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
