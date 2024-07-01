extends Camera2D

#region CameraShake
# How quickly to move through the noise
const NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
const NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
const SHAKE_DECAY_RATE: float = 3.0
var noise = FastNoiseLite.new()
#Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
var shake_strength: float = 0.0
#endregion

var in_boss_area := false

func _ready() -> void:
	noise.frequency = 2
	reset_smoothing()

func _process(delta: float) -> void:
#region CameraShake
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = get_noise_offset(delta)
#endregion
	if %Player.is_on_floor() and not in_boss_area:
		limit_bottom = %Player.position.y + 144
		limit_top = %Player.position.y - 144
		if limit_bottom > 368:
			limit_bottom = 368

#region CameraShake
func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(10, noise_i) * shake_strength
	)
#endregion

func _on_menu_glow(toggled_on):
	($"../WorldEnvironment" as WorldEnvironment).environment.glow_enabled = toggled_on
func _on_menu_hdr(toggled_on):
	ProjectSettings.set_setting("rendering/viewport/hdr_2d",toggled_on)
	get_viewport().use_hdr_2d=toggled_on


func _on_boss_starter_body_entered(body: Node2D) -> void:
	if body is Player:
		apply_noise_shake()
		in_boss_area = true
		#INFO PLayer.position + half screenwidth + constant
		limit_bottom = -364 + 144 - 115
		limit_top = -364 - 144 - 115
