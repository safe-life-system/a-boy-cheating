extends Area2D

signal presed
signal relised

var bodies_on_button := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	bodies_on_button += 1
	if bodies_on_button >= 1:
		$Sprite2D.visible = false
		$Sprite2D2.visible = true
		emit_signal("presed")

func _on_body_exited(body: Node2D) -> void:
	bodies_on_button -= 1
	if bodies_on_button == 0:
		$Sprite2D.visible = true
		$Sprite2D2.visible = false
		emit_signal("relised")
