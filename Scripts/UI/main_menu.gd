extends Control


func _ready() -> void:
	Global.menu = true
	$AudioStreamPlayer.play()
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scens/UI/intro.tscn")
	Global.menu = false




func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
