extends RigidBody2D

@onready var ANIM: AnimatedSprite2D = $AnimatedSprite2D
const ANGULAR_VELOCITY_CONSTANT = 0.04

func _ready():
	ANIM.play("up")
	apply_impulse(Vector2(0,-400),position)
	angular_velocity = ANGULAR_VELOCITY_CONSTANT * linear_velocity.x
	
func _process(_delta):
	if linear_velocity.y > 0:
		if linear_velocity.x == 0:
			ANIM.flip_v = true
		if ANIM.animation == "up":
			ANIM.play("turn")
		elif (ANIM.animation == "turn" and not ANIM.is_playing()):
			ANIM.play("down")


func _on_timer_timeout() -> void:
	queue_free()
