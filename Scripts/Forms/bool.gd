class_name Bool
extends Transformable

const SPEED := 200.0
const GRAVITY := 900.0
const JUMP_VELOCITY = -560.0
const BOUNCE = 0.6
var jump_buffered = false
@onready var land_particles: GPUParticles2D = $LandParticles

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		jump_buffered = true

# Переопределяем метод родителя
func get_vector() -> Vector2:
	var vel := velocity
	if jump_buffered and is_on_floor():
		vel.y = JUMP_VELOCITY
		jump_buffered = false
	if not is_occupied:
		return Vector2.ZERO
	
	  # берём текущую velocity объекта
	
	# Гравитация всегда действует
	if not is_on_floor():
		vel.y += GRAVITY * get_physics_process_delta_time()
	
	# Горизонталь — только если игрок внутри
	var input := Input.get_axis("ui_left", "ui_right")

	if input != 0:
		# Игрок жмёт — разгоняемся
		vel.x = lerp(vel.x, input * SPEED, 0.15)
	else:
		# Игрок не жмёт — замедляемся медленно (инерция)
		vel.x = lerp(vel.x, 0.0, 0.03)  # 0.03 = долго тормозит
	if is_on_floor() and velocity.y > 50:
		land_particles.emitting = true
		vel.y = -velocity.y * BOUNCE
	if abs(vel.x) > 5:
		rotation += velocity.x * 0.001
	
	return vel

func apply_bounce(pre_velocity: Vector2) -> void:
	if is_on_floor() and pre_velocity.y > 50:
		velocity.y = -pre_velocity.y * BOUNCE
func die():
	$DieAudio.play()
	ResetMenu.show_menu()
