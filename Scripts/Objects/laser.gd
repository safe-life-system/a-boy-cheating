extends Node2D

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var area: Area2D = $Area2D
@onready var area_shape: CollisionShape2D = $Area2D/CollisionShape2D

const MAX_LENGTH := 300.0

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var end_points = get_end_points()
	_update_visual(end_points)
	_update_area(end_points)
	

func get_end_points():
	if ray_cast.is_colliding():
		return to_local(ray_cast.get_collision_point())
	else:
		return Vector2(MAX_LENGTH, 0)

func _update_visual(end_point: Vector2):
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(end_point)

func _update_area(end_point: Vector2):
	var lenght = end_point.length()
	area.position = end_point/2
	area_shape.shape.size = Vector2(lenght, 4)
