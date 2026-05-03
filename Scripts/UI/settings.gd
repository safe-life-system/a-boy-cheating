extends CanvasLayer

const RESOLUTION = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

@onready var music_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer2/SFXSlider
@onready var resolution_option: OptionButton = $PanelContainer/VBoxContainer/HBoxContainer3/ResolutionOption
@onready var full_screen_check: CheckButton = $PanelContainer/VBoxContainer/HBoxContainer4/FullScreenCheck

func _ready() -> void:
	visible = false
	
	for res in RESOLUTION:
		resolution_option.add_item(str(res.x)+"x"+str(res.y))
	if OS.has_feature("mobile"):
		resolution_option.visible = false
		full_screen_check.visible = false
	_load_settings()



func _save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.set_value("video", "resolution", resolution_option.selected)
	config.set_value("video", "fullscreen", full_screen_check.button_pressed)
	config.save("user://settings.cfg")

func _load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return
	
	music_slider.value = config.get_value("audio", "music", 1.0)
	sfx_slider.value = config.get_value("audio", "sfx", 1.0)
	resolution_option.selected = config.get_value("video", "resolution", 0)
	full_screen_check.button_pressed = config.get_value("video", "fullscreen", false)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))



func _on_resolution_option_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION[index])
	_center_window()

func _center_window() -> void:
	var screen = DisplayServer.screen_get_size()
	var window = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen - window) / 2)
	



func _on_full_screen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_back_pressed() -> void:
	_save_settings()
	visible = false
