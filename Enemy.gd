extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var is_dead = false


func _ready():
	pass # Replace with function body.

func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$CollisionShape2D.scale.x *= 1.5
	$CollisionShape2D.scale.y *= 0.5
	
	$AnimatedSprite.play("dead")

func _physics_process(delta):
	if is_dead == false:
		# Speed and direction for walking
		velocity.x = SPEED * direction
		
		# If the enemy hits a wall, flip the sprite
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			
		# Play the sprite
		$AnimatedSprite.play("walk")
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)

	# If the enemy hits a wall change the direction
	if is_on_wall():
		direction *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1
