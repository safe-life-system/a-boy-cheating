extends Path2D

@export var speed := 100.0
@export var loop := true  # туда-обратно
var move = false

@onready var follow := $PathFollow2D
var direction := 1.0

func _ready() -> void:
	follow.loop = loop

func _physics_process(delta: float) -> void:
	if not move:
		return
	follow.progress += speed * direction * delta

func move_start():
	move = true

func move_stop():
	move = false
