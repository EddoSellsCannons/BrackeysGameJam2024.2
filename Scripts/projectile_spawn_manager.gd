extends Node2D

@onready var gameManager = $".."

@onready var small_projectile_spawn_timer: Timer = $smallProjectileSpawnTimer
@onready var med_proj_spawn_timer: Timer = $medProjSpawnTimer
@onready var survivor_spawn_timer: Timer = $survivorSpawnTimer
@onready var small_obstacle_timer: Timer = $smallObstacleTimer
@onready var large_obstacle_timer: Timer = $largeObstacleTimer

@onready var left_marker: Marker2D = $leftMarker
@onready var right_marker: Marker2D = $rightMarker

@onready var obstacle_spawnpoint: Marker2D = $obstacleSpawnpoint
@onready var obstacle_spawnpoint_2: Marker2D = $obstacleSpawnpoint2
@onready var obstacle_spawnpoint_3: Marker2D = $obstacleSpawnpoint3
@onready var obstacle_spawnpoint_4: Marker2D = $obstacleSpawnpoint4
@onready var obstacle_spawnpoint_5: Marker2D = $obstacleSpawnpoint5
var obstacle_spawnpoint_array: Array

@onready var smallProjectile = preload("res://Scenes/small_projectile.tscn")
@onready var medProjectile = preload("res://Scenes/medium_projectile.tscn")

@onready var smallObstacle = preload("res://Scenes/small_obstacle.tscn")
@onready var largeObstacle = preload("res://Scenes/large_obstacle.tscn")

@onready var survivor = preload("res://Scenes/survivor.tscn")

var prevScoreVal = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	obstacle_spawnpoint_array = [obstacle_spawnpoint, obstacle_spawnpoint_2, obstacle_spawnpoint_3, obstacle_spawnpoint_4, obstacle_spawnpoint_5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fmod(gameManager.score, 50) == 0 and prevScoreVal != gameManager.score:
		prevScoreVal = gameManager.score
		var timerModifier = 1 - gameManager.score * 0.01 / 100
		small_projectile_spawn_timer.stop()
		small_projectile_spawn_timer.wait_time = small_projectile_spawn_timer.wait_time * timerModifier
		small_projectile_spawn_timer.start()
		
		med_proj_spawn_timer.stop()
		med_proj_spawn_timer.wait_time = med_proj_spawn_timer.wait_time * timerModifier
		med_proj_spawn_timer.start()
		
		small_obstacle_timer.stop()
		small_obstacle_timer.wait_time = small_obstacle_timer.wait_time * timerModifier
		small_obstacle_timer.start()
		
		large_obstacle_timer.stop()
		large_obstacle_timer.wait_time = large_obstacle_timer.wait_time * timerModifier
		large_obstacle_timer.start()
		
		survivor_spawn_timer.stop()
		survivor_spawn_timer.wait_time = survivor_spawn_timer.wait_time * timerModifier
		survivor_spawn_timer.start()

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
	s.position = obstacle_spawnpoint_array.pick_random().position
	s.set_linear_velocity(Vector2(-randf_range(50, 150), randf_range(0, -50)))
	add_child(s)
	
func spawnSmallObstacle():
	var obstacle = smallObstacle.instantiate()
	obstacle.position = obstacle_spawnpoint_array.pick_random().position
	obstacle.set_linear_velocity(Vector2(-randf_range(100, 300), randf_range(-50, 50)))
	add_child(obstacle)
	
func spawnLargeObstacle():
	var obstacle = largeObstacle.instantiate()
	obstacle.position = obstacle_spawnpoint_array.pick_random().position
	obstacle.set_linear_velocity(Vector2(-randf_range(25, 100), randf_range(-50, 50)))
	add_child(obstacle)

func _on_small_projectile_spawn_timer_timeout() -> void:
	spawnSmallProjectile()

func _on_med_proj_spawn_timer_timeout() -> void:
	if gameManager.score >= 100:
		spawnMedProjectile()

func _on_survivor_spawn_timer_timeout() -> void:
	spawnSurvivorObject()

func _on_small_obstacle_timer_timeout() -> void:
	spawnSmallObstacle()

func _on_large_obstacle_timer_timeout() -> void:
	if gameManager.score >= 300:
		spawnLargeObstacle()
