extends Area2D

@export var next_scens: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D):
	if body.has_method("set_nearby_form"):
		if Global.leave_key > 0:
			get_tree().change_scene_to_packed(next_scens)
