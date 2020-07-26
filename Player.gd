extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://Fireball.tscn")
const FIREBALL_REVERSE = preload("res://Fireball_reverse.tscn")

var velocity = Vector2()
var on_ground = false
var is_attacking = false

func _physics_process(delta):
	# Right/Left movement
	if Input.is_action_pressed("ui_right"):
		# Stops attack from being interrupted
		if is_attacking == false or  is_on_floor() == false:
			velocity.x = SPEED
			# While jumping, this stops the animation from flipping
			if is_attacking == false:
				# Run animation
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("run")
				
				# This controls fireball direction depending on the way you're looking
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		# Check if the attack animation needs to be played
		# Stops attack from being interrupted
		if is_attacking == false or is_on_floor() == false:
			velocity.x = -SPEED
			if is_attacking == false:
				# Run animation
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("run")
				
				# This controls fireball direction depending on the way you're looking
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x = 0
		# Idle animation
		if on_ground && is_attacking == false:
			$AnimatedSprite.play("idle")
	
	# Jumping
	if Input.is_action_pressed("ui_up") and on_ground and is_attacking == false:
		velocity.y = JUMP_POWER
		on_ground = false
		
	# Check if we're on the ground
	if is_on_floor():
		# Cancle attack animation when you land
		if on_ground == false:
			is_attacking = false
			on_ground = true
	else:
		# Stops attack from being interrupted
		if is_attacking == false:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				# Need to put a fall animation here
				$AnimatedSprite.play("jump")
	
	# Fireball firing
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		# Stops moving while firing
		if is_on_floor():
			velocity.x = 0
		is_attacking = true
		$AnimatedSprite.play("attack_one")
		var fireball = FIREBALL.instance()
		var fireball_reverse = FIREBALL_REVERSE.instance()
		if sign($Position2D.position.x) == 1:
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		else:
			get_parent().add_child(fireball_reverse)
			fireball_reverse.position = $Position2D.global_position
		

	velocity.y += GRAVITY
	
	
	velocity = move_and_slide(velocity, FLOOR)


func _on_AnimatedSprite_animation_finished():
	is_attacking = false
