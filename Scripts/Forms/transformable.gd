class_name Transformable
extends CharacterBody2D

# Переменные состояния
var is_occupied := false   # игрок сейчас внутри?

# Вызывается из Player когда игрок входит
func on_enter() -> void:
	is_occupied = true

# Вызывается из Player когда игрок выходит
func on_exit() -> void:
	is_occupied = false

# Каждый наследник переопределит этот метод по-своему
func get_vector() -> Vector2:
	return Vector2.ZERO



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("set_nearby_form"):
		print(body)
		body.set_nearby_form(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("set_nearby_form"):
		body.set_nearby_form(null)
