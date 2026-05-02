class_name Bool
extends Transformable

const SPEED := 200.0
const GRAVITY := 900.0
const JUMP_VELOCITY = -560.0
const BOUNCE = 0.6

# Переопределяем метод родителя
func get_vector() -> Vector2:
	if not is_occupied:
		return Vector2.ZERO
	
	var vel := velocity  # берём текущую velocity объекта
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		vel.y = JUMP_VELOCITY
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
		vel.y = -velocity.y * BOUNCE
	if abs(vel.x) > 5:
		rotation += velocity.x * 0.001
	
	return vel

func apply_bounce(pre_velocity: Vector2) -> void:
	if is_on_floor() and pre_velocity.y > 50:
		velocity.y = -pre_velocity.y * BOUNCE
func die():
	get_tree().reload_current_scene()
