extends Area2D


func _on_body_entered(body: Node2D):
	if body is Player:
		PlayerAutoLoad.health += 1
		queue_free()
