extends Area2D

var speed := 300

func _process(delta: float):
	position += speed * Vector2.from_angle(rotation-PI/2) * delta
	
func _on_body_entered(body: Node) -> void:
	$AnimatedSprite2D.play("default")
	$BulletSprite2D.visible = false
	speed = 0
	if body is Player:
		PlayerAutoLoad.health -= 1


func _on_gpu_particles_2d_finished() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
