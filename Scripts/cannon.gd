extends Node2D

@onready var cannonball = preload("res://Scenes/cannonball.tscn")

@onready var player = $".."

func fireCannonball():
	var c = cannonball.instantiate()
	c.position = global_position
	get_tree().root.get_node("transitionManager/bossFightManager/playerProj").add_child(c)
	
func _on_timer_timeout() -> void:
	fireCannonball()
