extends Node2D

@onready var gameManager = $".."

@onready var left_marker: Marker2D = $leftMarker
@onready var right_marker: Marker2D = $rightMarker

@onready var smallProjectile = preload("res://Scenes/small_projectile.tscn")
@onready var medProjectile = preload("res://Scenes/medium_projectile.tscn")

@onready var survivor = preload("res://Scenes/survivor.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
func spawnSmallProjectile():
	#Randomise proj with weighting
	var proj = smallProjectile.instantiate()
	proj.position.x = randf_range(left_marker.position.x, right_marker.position.x) + 300
	proj.position.y = position.y - 200
	proj.set_linear_velocity(Vector2(-randf_range(0, 200), 0))
	add_child(proj)

func spawnMedProjectile():
	#Randomise proj with weighting
	var proj = medProjectile.instantiate()
	proj.position.x = randf_range(left_marker.position.x, right_marker.position.x) + 300
	proj.position.y = position.y - 200
	proj.set_linear_velocity(Vector2(-randf_range(0, 300), 0))
	add_child(proj)
	
func spawnSurvivorObject():
	var s = survivor.instantiate()
	s.position.x = randf_range(left_marker.position.x, right_marker.position.x) + 300
	s.position.y = position.y - 200
	s.set_linear_velocity(Vector2(-randf_range(0, 300), 0))
	add_child(s)

func _on_small_projectile_spawn_timer_timeout() -> void:
	spawnSmallProjectile()

func _on_med_proj_spawn_timer_timeout() -> void:
	if gameManager.score >= 100:
		spawnMedProjectile()

func _on_survivor_spawn_timer_timeout() -> void:
	spawnSurvivorObject()
