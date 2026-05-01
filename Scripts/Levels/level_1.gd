extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	$Button.presed.connect($SifiDoor.open)
	$Button.relised.connect($SifiDoor.close)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
