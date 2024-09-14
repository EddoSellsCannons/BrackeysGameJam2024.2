extends Area2D

@export var damage: float

func _ready() -> void:
	$AnimationPlayer.play("lightningStrike")
