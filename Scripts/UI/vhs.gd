extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("mobile"):
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
