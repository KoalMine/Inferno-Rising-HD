extends Area2D
class_name Engines

signal all_engines_destroyed 

static var total_engines_left: int = 0
var health := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	total_engines_left += 1

func _process(_delta):
	print(total_engines_left)
	if total_engines_left == 0:
		all_engines_destroyed.emit()

func _on_body_entered():
	if health > 0:
		health -= 1
		if health == 0:
			destroy_engine()

func destroy_engine():
	$WorkingEngine.visible = false
	$BrokenEngine.visible = true
	$Explosion.play("default")
	total_engines_left -= 1
