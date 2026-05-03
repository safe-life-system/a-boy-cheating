extends Control
const SCROLL_SPEED = 100
var finished = false

@onready var container := $CanvasLayer/ScrollContainer
@onready var vbox := $CanvasLayer/ScrollContainer/VBoxContainer


func _physics_process(delta: float) -> void:
	if finished:
		return
	
	container.scroll_vertical += SCROLL_SPEED * delta
	
	var max_scroll = vbox.size.y - container.size.y
	if container.scroll_vertical >= max_scroll:
		Global.menu = true
		finished = true
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scens/UI/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scens/UI/main_menu.tscn")
