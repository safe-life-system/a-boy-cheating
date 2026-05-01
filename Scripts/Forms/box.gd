class_name Box
extends Transformable

const SPEED := 80.0
const GRAVITY := 900.0

# Переопределяем метод родителя
func get_vector() -> Vector2:
	if not is_occupied:
		return Vector2.ZERO
	
	var vel := velocity  # берём текущую velocity объекта
	
	# Гравитация всегда действует
	if not is_on_floor():
		vel.y += GRAVITY * get_physics_process_delta_time()
	
	# Горизонталь — только если игрок внутри
	vel.x = Input.get_axis("ui_left", "ui_right") * SPEED
	
	return vel
