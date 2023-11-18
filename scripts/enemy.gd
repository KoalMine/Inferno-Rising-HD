extends Area2D

var health := 1

func _on_body_entered() -> void:
	if health > 0:
		health -= 1
		if health == 0:
			var tween: Tween = get_tree().create_tween()
			tween.tween_property(self,"modulate:a",0,1)
			tween.tween_callback(queue_free)
