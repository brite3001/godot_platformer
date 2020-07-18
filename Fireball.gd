extends Area2D

const SPEED = 150
var velocity = Vector2()
var direction = 1

func _physics_process(delta):
	# Move and slide uses delta automatically, but here we keep it simple as we're only moving horizontally
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

# This removes the fireball from memory once it goes off the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
# Helper func used by Player to decide the direction of the fireball
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

# Kills the fireball when it hits a wall
func _on_Fireball_body_entered(body):
	queue_free()
