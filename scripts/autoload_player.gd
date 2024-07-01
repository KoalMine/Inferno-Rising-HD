extends Node

signal health_changed
signal dead

var playerpos: Vector2
var health : int = 4:
	set(value):
		if value > 0:
			health = value
			health_changed.emit()
		elif value == 0:
			health = 0
			dead.emit()
	get: 
		return health
