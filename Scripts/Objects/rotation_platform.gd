extends StaticBody2D

@export var speed = 60.0
@export var correct_angle := 0.0
@export var tolerance := 10.0
var is_rotation = false

func is_correct() -> bool:
	return abs(rotation_degrees - correct_angle) < tolerance
func _ready() -> void:
	rotation_degrees = randf_range(0.0, 360.0)

func _physics_process(delta: float) -> void:
	if is_rotation:
		rotation_degrees += speed * delta

func start_rotation():
	is_rotation = true

func stop_rotation():
	is_rotation = false
	var target = snappedf(rotation_degrees, 45.0)
	rotation_degrees = target

# Called every frame. 'delta' is the elapsed time since the previous frame.
