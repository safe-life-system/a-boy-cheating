extends Node2D

@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_name = Global.spawn_point
	if has_node(spawn_name):
		player.position = get_node(spawn_name).position
	$Button.presed.connect($SifiDoor.open)
	$Button.relised.connect($SifiDoor.close)
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
