extends Node

signal health_changed

var playerpos: Vector2
var health : int = 4:
	set(value):
		if value >= 0:
			health = value
			health_changed.emit()
		else:
			print("youre dead\t",health)
	get: 
		return health
		

