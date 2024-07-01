extends Node2D

signal laser_finished
signal drill_finished

@onready var Drill: Area2D = %Drill
@onready var DrillCollision: CollisionPolygon2D = %Drill/Collision
@onready var LaserGun: Sprite2D = %LaserGun
@onready var LaserGunCollision: CollisionShape2D = %LaserGun/RedLaser/CollisionShape2D
@onready var Arm: Sprite2D = %Arm
@onready var DrillLine: Sprite2D = %DrillLine
@onready var Head: Sprite2D = %Head
@onready var BossStarter: Area2D = $"../BossStarter"
@onready var Anim: AnimationPlayer = $AnimationPlayer
@onready var Anim2: AnimationPlayer = $AnimationPlayer2
@onready var Exploders: Node2D = $Exploders

func _process(_delta) -> void:
	pass
		
#region States
func drill_to_normal_state() -> void:
	# Drill go to default scale and position
	Drill.scale = Vector2(0.75,0.75)
	Drill.z_index = 0
	Drill.position = Vector2(0,0)
	DrillLine.visible = false
	DrillCollision.disabled = true
	#
	# Arm lower and Drill appear from bottom then raise
	await create_tween().tween_property(Arm,"rotation",-PI/2,1).finished
	Drill.rotation = -PI/2
	Drill.visible = true
	var tween = create_tween()
	tween.tween_property(Arm,"rotation",0,1)
	await tween.parallel().tween_property(Drill,"rotation",0,1).finished
	await get_tree().create_timer(1.1).timeout
	#
	await get_tree().create_timer(3).timeout

func laser_to_normal_state():
	LaserGun.visible = false
	LaserGun.position.y = 50
	LaserGunCollision.disabled = true
	#
	await get_tree().create_timer(3).timeout

func drill_attack() -> void:
	DrillLine.visible = true
	#
	# Arm raise
	var tween = create_tween()
	tween.tween_property(Arm,"rotation_degrees",50,1)
	await tween.parallel().tween_property(Drill,"rotation_degrees",50,1).finished
	#
	# Drill drop
	Drill.rotation = 0
	Drill.scale = Vector2(1,1)
	Drill.z_index = 2
	Drill.position = Vector2(115,-200) # was x=88
	DrillCollision.disabled = false
	var tween2: Tween = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	await tween2.tween_property(Drill,"position:y",110,1).finished
	#
	# Drill go down and go invisible
	await create_tween().tween_property(Drill,"position:y",300,0.4).finished
	Drill.visible = false
	#
	await get_tree().create_timer(1).timeout
	drill_finished.emit()


func laser_sweep() -> void:
	LaserGun.visible = true
	LaserGunCollision.disabled = false
	await create_tween().tween_property(LaserGun,"position:y",-100,2).finished
	await get_tree().create_timer(1.5).timeout
	
	laser_finished.emit()


func _on_drill_finished() -> void:
	await drill_to_normal_state()
	if randi() % 2 == 0:
		drill_attack()
	else:
		laser_sweep()


func _on_laser_finished() -> void:
	await laser_to_normal_state()
	if randi() % 2 == 0:
		drill_attack()
	else:
		laser_sweep()
#endregion

func _on_drill_body_entered(body) -> void:
	if body is Player:
		PlayerAutoLoad.health -= 1


func _on_red_laser_body_entered(body) -> void:
	if body is Player:
		PlayerAutoLoad.health -= 1


func _on_boss_starter_body_entered(body: Node2D) -> void:
	if body is Player:
		BossStarter.queue_free()
		for child: Light2D in Head.get_children():
			if child.name == "PointLight2D4":
				Anim.play("HeadBob")
			child.visible = true
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(2).timeout
		Anim2.play("HandWave")
		await get_tree().create_timer(4).timeout
		Anim2.stop()
		await get_tree().create_timer(2).timeout
		await drill_attack()

func death() -> void:
	for explodees: AnimatedSprite2D in Exploders.get_children():
		explodees.play("default")
		await get_tree().create_timer(0.2).timeout
	for explodees: AnimatedSprite2D in Exploders.get_children():
		explodees.play("default")
		await get_tree().create_timer(0.2).timeout
	queue_free()
	#engines.free() # Free the script

func _on_engine_parts_all_engines_destroyed() -> void:
	death()
