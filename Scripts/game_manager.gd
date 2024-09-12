extends Node2D

@onready var health_bar: TextureProgressBar = $CanvasLayer/healthBar
@onready var boost_bar: TextureProgressBar = $CanvasLayer/boostBar
@onready var shield_bar: TextureProgressBar = $CanvasLayer/shieldBar

@onready var projectile_delete_bar: HBoxContainer = $CanvasLayer/projectileDeleteBar

@onready var player: CharacterBody2D = $Player

@onready var transition_manager = $".."

var score: float
var rescuedCount: int = 0

func _ready() -> void:
	player.usedProjDeleter.connect(projectile_delete_bar.usedProjDeleter)

func _on_void_area_body_entered(body: Node2D) -> void:
	body.queue_free()

func _process(delta: float) -> void:
	updateBars()
	
func updateBars():
	health_bar.value = (player.playerCurHealth/player.playerMaxHealth) * 100
	shield_bar.value = (player.playerCurShield/player.playerMaxShield) * 100
	boost_bar.value = (player.playerCurStamina/player.playerMaxStamina) * 100

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/scoreLabel.text = str(score) + "m"

func gameOver():
	#play anim for game over
	transition_manager.villageStart(score, rescuedCount)
	queue_free()
