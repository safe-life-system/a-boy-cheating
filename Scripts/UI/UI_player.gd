extends Control
@onready var energy_bar: TextureProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/EnergyBar
@onready var label: Label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Sprite2D/Label


func _ready() -> void:
	energy_bar.value = 100.0
	energy_bar.max_value = 100.0
# Вызывается из Player когда энергия меняется
func update_energy(current: float, max_energy: float) -> void:
	energy_bar.max_value = max_energy
	energy_bar.value = current

func _physics_process(delta: float) -> void:
	label.text = "X"+str(Global.leave_key)
