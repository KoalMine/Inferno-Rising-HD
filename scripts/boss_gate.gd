extends TileMap

func _process(_delta):
	if Engines.total_engines_left == 0:
		queue_free()
