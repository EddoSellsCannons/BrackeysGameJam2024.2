extends RigidBody2D

@export var damage: float
@onready var animation_player = $AnimationPlayer

func playInkSplatter():
	$Sprite2D.visible = false
	animation_player.play("inkSplatter")
