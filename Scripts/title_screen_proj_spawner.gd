extends Node2D

@onready var sProj = preload("res://Scenes/title_screen_small_proj.tscn")
@onready var mProj = preload("res://Scenes/title_screen_med_proj.tscn")

@onready var left_marker: Marker2D = $leftMarker
@onready var right_marker: Marker2D = $rightMarker

func _on_timer_timeout() -> void:
	var p = sProj.instantiate()
	p.position = Vector2(randi_range(left_marker.global_position.x, right_marker.global_position.x), -250)
	add_child(p)
	
	var p2 = mProj.instantiate()
	p2.position = Vector2(randi_range(left_marker.global_position.x, right_marker.global_position.x), -250)
	add_child(p2)
