extends Node2D

func _on_start_button_down() -> void:
	if get_tree().root.get_node("transitionManager") == null:
		get_tree().root.add_child(load("res://Scenes/transition_manager.tscn").instantiate())
	queue_free()
