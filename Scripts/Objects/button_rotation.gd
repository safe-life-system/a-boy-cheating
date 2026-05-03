extends Area2D

@export var platform: Array[NodePath]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
	for path in platform:
		get_node(path).start_rotation()


func _on_body_exited(body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
	for path in platform:
		get_node(path).stop_rotation()
