extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var point_light_2d: PointLight2D = $PointLight2D
var open_check = false


func open():
	if not open_check:
		point_light_2d.color = "#2d7500"
		collision_layer = 0
		collision_mask = 0
		$AnimatedSprite2D.play("open")
		$AudioStreamPlayer2D.play(3.6)
		open_check = true

func close():
	if open_check:
		point_light_2d.color = "#bb0006"
		collision_layer = 2
		collision_mask = 2
		$AnimatedSprite2D.play("default")
		$AudioStreamPlayer2D.play(3.8)
		open_check = false
