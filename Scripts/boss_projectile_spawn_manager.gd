extends Node2D

@onready var gameManager = $".."

@onready var small_projectile_spawn_timer: Timer = $smallProjectileSpawnTimer
@onready var survivor_spawn_timer: Timer = $survivorSpawnTimer
@onready var large_obstacle_timer: Timer = $largeObstacleTimer

@onready var left_marker: Marker2D = $leftMarker
@onready var right_marker: Marker2D = $rightMarker

@onready var obstacle_spawnpoint: Marker2D = $obstacleSpawnpoint
@onready var obstacle_spawnpoint_2: Marker2D = $obstacleSpawnpoint2
@onready var obstacle_spawnpoint_3: Marker2D = $obstacleSpawnpoint3
@onready var obstacle_spawnpoint_4: Marker2D = $obstacleSpawnpoint4
@onready var obstacle_spawnpoint_5: Marker2D = $obstacleSpawnpoint5
var obstacle_spawnpoint_array: Array

@onready var tentacle_slam_spawnpoint: Marker2D = $tentacleSlamSpawnpoint
@onready var tentacle_slam_spawnpoint_2: Marker2D = $tentacleSlamSpawnpoint2
@onready var tentacle_slam_spawnpoint_3: Marker2D = $tentacleSlamSpawnpoint3
var tentacle_slam_spawnpoint_array: Array

@onready var smallProjectile = preload("res://Scenes/ink_proj.tscn")

@onready var largeObstacle = preload("res://Scenes/boss_obstacle.tscn")

@onready var survivor = preload("res://Scenes/survivor.tscn")

@onready var tentacleSlam = preload("res://Scenes/tentacle_slam_attack.tscn")

var prevScoreVal = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	obstacle_spawnpoint_array = [obstacle_spawnpoint, obstacle_spawnpoint_2, obstacle_spawnpoint_3, obstacle_spawnpoint_4, obstacle_spawnpoint_5]
	tentacle_slam_spawnpoint_array = [tentacle_slam_spawnpoint, tentacle_slam_spawnpoint_2, tentacle_slam_spawnpoint_3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fmod(gameManager.score, 50) == 0 and prevScoreVal != gameManager.score:
		prevScoreVal = gameManager.score
		var timerModifier = 1 - gameManager.score * 0.01 / 100
		small_projectile_spawn_timer.stop()
		small_projectile_spawn_timer.wait_time = small_projectile_spawn_timer.wait_time * timerModifier
		small_projectile_spawn_timer.start()
		
		large_obstacle_timer.stop()
		large_obstacle_timer.wait_time = large_obstacle_timer.wait_time * timerModifier
		large_obstacle_timer.start()

func spawnSmallProjectile():
	#Randomise proj with weighting
	var proj = smallProjectile.instantiate()
	proj.position.x = randf_range(left_marker.position.x, right_marker.position.x) + 300
	proj.position.y = position.y - 200
	proj.set_linear_velocity(Vector2(-randf_range(0, 200), 0))
	add_child(proj)
	
func spawnSurvivorObject():
	var s = survivor.instantiate()
	s.position = obstacle_spawnpoint_array.pick_random().position
	s.set_linear_velocity(Vector2(-randf_range(50, 150), randf_range(0, -50)))
	add_child(s)

func _on_small_projectile_spawn_timer_timeout() -> void:
	spawnSmallProjectile()

func _on_survivor_spawn_timer_timeout() -> void:
	spawnSurvivorObject()

func _on_tentacle_slam_timer_timeout() -> void:
	var tentacleSlamProj1 = tentacleSlam.instantiate()
	tentacleSlamProj1.position = tentacle_slam_spawnpoint.global_position
	var tentacleSlamProj2 = tentacleSlam.instantiate()
	tentacleSlamProj2.position = tentacle_slam_spawnpoint_2.global_position
	var tentacleSlamProj3 = tentacleSlam.instantiate()
	tentacleSlamProj3.position = tentacle_slam_spawnpoint_3.global_position
	
	var tentacleSlamArray:Array = [tentacleSlamProj1, tentacleSlamProj2, tentacleSlamProj3]
	
	var safeTentacle = randi_range(0,2)
	var tentacleIndex = 0
	for i in tentacleSlamArray:
		if tentacleIndex == safeTentacle:
			i.get_node("animation_player").play("tentacleSafe")
		else:
			i.get_node("animation_player").play("tentacleAttack")
		add_child(i)
		tentacleIndex += 1

func _on_large_obstacle_timer_timeout() -> void:
	var obstacle = largeObstacle.instantiate()
	obstacle.position = obstacle_spawnpoint_array.pick_random().position
	obstacle.set_linear_velocity(Vector2(-randf_range(300, 400), 0))
	add_child(obstacle)
