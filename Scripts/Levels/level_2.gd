extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.presed.connect($MovingPlatform.move_start)
	$Button.relised.connect($MovingPlatform.move_stop)
	$Triger.triger.connect(func():$Player.zoom_camera(1,1, -200.915))
	$Button2.presed.connect($SifiDoor.open)
	$Button2.relised.connect($SifiDoor.close)
	if not Global.menu:
		$AudioStreamPlayer.autoplay = true
		$AudioStreamPlayer.play()
	if OS.has_feature("mobile"):
		for light in get_tree().get_nodes_in_group("lights"):
			light.shadow_enabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
