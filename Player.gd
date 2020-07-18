extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://Fireball.tscn")

var velocity = Vector2()
var on_ground = false;

func _physics_process(delta):
	# Right/Left movement
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		# Run animation
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
		
		# This controls fireball direction depending on the way you're looking
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		# Run animation
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
		
		# This controls fireball direction depending on the way you're looking
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	else:
		velocity.x = 0
		# Idle animation
		if on_ground:
			$AnimatedSprite.play("idle")
	
	# Jumping
	if Input.is_action_pressed("ui_up") and on_ground:
		velocity.y = JUMP_POWER
		on_ground = false
		
	# Check if we're on the ground
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			# Need to put a fall animation here
			$AnimatedSprite.play("jump")
	
	# Fireball firing
	if Input.is_action_just_pressed("ui_focus_next"):
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		

	velocity.y += GRAVITY
	
	
	velocity = move_and_slide(velocity, FLOOR)
