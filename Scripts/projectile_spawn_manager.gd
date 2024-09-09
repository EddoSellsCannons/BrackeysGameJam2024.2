extends Node2D

@onready var left_marker: Marker2D = $leftMarker
@onready var right_marker: Marker2D = $rightMarker

@onready var smallProjectile = preload("res://Scenes/small_projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_small_projectile_spawn_timer_timeout() -> void:
	spawnSmallProjectile()
	
func spawnSmallProjectile():
	#Randomise proj with weighting
	var proj = smallProjectile.instantiate()
	proj.position.x = randf_range(left_marker.position.x, right_marker.position.x) + 300
	proj.position.y = position.y - 200
	proj.set_linear_velocity(Vector2(-randf_range(0, 300), 0))
	add_child(proj)
