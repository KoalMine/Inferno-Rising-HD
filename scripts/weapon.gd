extends Node2D

const BulletScene = preload("res://scenes/bullet.tscn")
const LERP_CONSTANT = 0.1

@onready var body_sprite: Sprite2D = $"../Body"

func _ready():
	$RedLine.add_point(Vector2(0,0))
	$WeaponSprite.rotation = PI


func _physics_process(_delta):
	$DetectorRayCast.look_at(PlayerAutoLoad.playerpos)
	var RayRot: int = $DetectorRayCast.rotation_degrees
	RayRot = wrapi(RayRot, 0, 360)
	
	# NOTE: Collision Point in local coordinates
	var ColPoint: Vector2 = %LaserCast.get_collision_point()-global_position
	if $"..".modulate.a == 1: # NOTE: Enemy is still alive
		if 100 <= RayRot and RayRot <= 260:
			if body_sprite.scale.x == -1:
				create_tween().tween_property(body_sprite,"scale:x",1,0.2)
				$WeaponSprite.flip_v = true
			
			var angle: float = (PlayerAutoLoad.playerpos - global_position).angle()
			$WeaponSprite.rotation = lerp_angle($WeaponSprite.rotation, angle, LERP_CONSTANT)
			shoot_bullet(ColPoint)
		elif 80 >= RayRot or RayRot >= 260:
			if body_sprite.scale.x == 1:
				create_tween().tween_property(body_sprite,"scale:x",-1,0.2)
				$WeaponSprite.flip_v = false
			
			var angle: float = (PlayerAutoLoad.playerpos - global_position).angle()
			$WeaponSprite.rotation = lerp_angle($WeaponSprite.rotation, angle, LERP_CONSTANT)
			shoot_bullet(ColPoint)
		else:
			# NOTE: Checks which side its looking at to return to default state
			var proximity: bool = body_sprite.scale.x <= 0
			if proximity:
				$WeaponSprite.rotation_degrees = lerpf($WeaponSprite.rotation_degrees, 0, LERP_CONSTANT)
			else:
				$WeaponSprite.rotation_degrees = lerpf($WeaponSprite.rotation_degrees, 180, LERP_CONSTANT)
		$RedLine.set_point_position(1,ColPoint)

func shoot_bullet(ColPoint: Vector2) -> void:
	if( 
		%LaserCast.get_collider() is Player
		and $DelayBetweenShots.time_left == 0
	):
		var bullet: Area2D = BulletScene.instantiate()
		bullet.rotate(ColPoint.angle()) # PI/2 to get the bullet to look right
		add_child(bullet)
		
		$DelayBetweenShots.start()
	else:
		pass
