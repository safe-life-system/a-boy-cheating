extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func show_menu():
	visible = true
	get_tree().paused = true

func hide_menu():
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	hide_menu()


func _on_menu_pressed() -> void:
	visible = false
	Global.menu = true
	get_tree().change_scene_to_file("res://Scens/UI/main_menu.tscn")
	hide_menu()
