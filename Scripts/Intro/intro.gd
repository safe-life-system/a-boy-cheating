extends Control

const TEXTS = [
	"Лабаратория XR-7. Закрытый объект",
	"Эксперемент 404 признан неудачным",
	"Субъект подлежит утилизациии",
	"О нет, что-то пошло не так",
	"Он выбрался на свободу и убил весь персонал",
	".....",
	"Я.... Я помню себя",
	"Я помню как трансформировался в другие объекты....",
	"С помощью 'E'....."
]
var CHAR_SPEED = 0.04
const PAUSE_AFTER = 1.8
@onready var label := $CanvasLayer/Label

var current_text := 0
var char_index := 0
var timer := 0.0
var waiting := false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += delta
	
	if waiting:
		if timer >= PAUSE_AFTER:
			current_text += 1
			if current_text >= TEXTS.size():
				_finish()
				return
			label.text = ""
			char_index = 0
			waiting = false
			timer = 0.0
		return
	if timer >= CHAR_SPEED:
		timer = 0.0
		if current_text >= 5:
			CHAR_SPEED = 0.1
		var full = TEXTS[current_text]
		if char_index < full.length():
			char_index += 1
			label.text = full.substr(0, char_index)
		else:
			waiting = true
			
func _finish() -> void:
	get_tree().change_scene_to_file("res://Scens/Levels/level_1.tscn")
