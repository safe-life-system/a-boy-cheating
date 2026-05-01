extends Control
@onready var energy_bar: TextureProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/EnergyBar

func _ready() -> void:
	energy_bar.value = 100.0
	energy_bar.max_value = 100.0
# Вызывается из Player когда энергия меняется
func update_energy(current: float, max_energy: float) -> void:
	energy_bar.max_value = max_energy
	energy_bar.value = current
