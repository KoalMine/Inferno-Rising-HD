class_name Player

extends CharacterBody2D

@onready var Anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var FireballContainer: Node2D = $".."/Environment

const SPEED = 100
const GRAVITY = 2300
const FirebalScene = preload("res://scenes/fireball.tscn")

func _ready():
	PlayerAutoLoad.connect("health_changed", animate_hit_effect)

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and $DelayBetweenShots.time_left == 0:
		$DelayBetweenShots.start()
		Anim.play("attack")
		$ShootDelay.start()
	if Anim.animation == "attack" and not Anim.is_playing():
		Anim.play("main")
	PlayerAutoLoad.playerpos = global_position
	
func _on_shoot_delay_timeout() -> void:
	var fireball: RigidBody2D = FirebalScene.instantiate()
	fireball.linear_velocity.x = get_real_velocity().x
	
	fireball.position.y = -10 + position.y
	if $AnimatedSprite2D.scale.x == -1: 
		fireball.position.x = -10 + position.x
	else:
		fireball.position.x = 10 + position.x
		
	FireballContainer.add_child(fireball)
	
#region Move
func get_input() -> void:
	velocity.x = 0
	if Input.is_action_pressed("right"):
		if $AnimatedSprite2D.scale.x == -1:
			create_tween().tween_property($AnimatedSprite2D,"scale:x",1,0.1)
		
		%TailParticles.position.x = -8
		velocity.x += SPEED
	if Input.is_action_pressed("left"):
		if $AnimatedSprite2D.scale.x == 1:
			create_tween().tween_property($AnimatedSprite2D,"scale:x",-1,0.1)
		
		%TailParticles.position.x = 8
		velocity.x += -SPEED
	if Input.is_action_just_pressed("up") and is_on_floor():
		%JumpParticles.emitting = true
		velocity.y = -500


func _physics_process(delta: float):
	get_input()
	velocity.y += GRAVITY * delta
	move_and_slide()
#endregion

func animate_hit_effect():
	($AnimatedSprite2D.material as ShaderMaterial).set_shader_parameter("blink_modifier",1)
	await get_tree().create_timer(0.1).timeout
	($AnimatedSprite2D.material as ShaderMaterial).set_shader_parameter("blink_modifier",0)
	
