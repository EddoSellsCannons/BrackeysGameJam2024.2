extends Node2D

var isActive: bool = false

func activateRaft():
	isActive = true

func _process(delta: float) -> void:
	if isActive:
		position.x -= 3
