extends Node2D

func _on_void_area_body_entered(body: Node2D) -> void:
	body.queue_free()
