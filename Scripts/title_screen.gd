extends Node2D

func _ready() -> void:
	$Control/deleteSave/notice.visible = false

func _on_start_button_down() -> void:
	if get_tree().root.get_node("transitionManager") == null:
		get_tree().root.add_child(load("res://Scenes/transition_manager.tscn").instantiate())
	queue_free()

func _on_delete_save_button_down() -> void:
	DirAccess.remove_absolute("user://savegame.save")
	DirAccess.remove_absolute("user://playerStats.tres")
	$Control/deleteSave/notice.visible = true

func _on_close_notice_button_down() -> void:
	$Control/deleteSave/notice.visible = false
