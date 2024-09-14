extends Node2D

@onready var lightningStrike = preload("res://Scenes/lightning_strike.tscn")

@onready var left_lightning_spawn: Marker2D = $"../leftLightningSpawn"
@onready var right_lightning_spawn: Marker2D = $"../rightLightningSpawn"


func spawnLightning():
	var xPos = randi_range(left_lightning_spawn.position.x, right_lightning_spawn.global_position.x)
	var yPos = randi_range(left_lightning_spawn.position.y, right_lightning_spawn.global_position.y)
	var l = lightningStrike.instantiate()
	l.position = Vector2(xPos, yPos)
	add_child(l)
