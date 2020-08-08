extends Area2D

const SPEED = 150
var velocity = Vector2()

func _physics_process(delta):
	# Move and slide uses delta automatically, but here we keep it simple as we're only moving horizontally
	velocity.x = SPEED * delta * 1
	translate(velocity)
	$AnimatedSprite.play("shoot")

# This removes the fireball from memory once it goes off the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Kills the fireball when it hits a wall
func _on_Fireball_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	queue_free()
