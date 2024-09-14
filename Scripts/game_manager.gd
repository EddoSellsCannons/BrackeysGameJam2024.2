extends Node2D

@onready var health_bar: TextureProgressBar = $CanvasLayer/healthBar
@onready var boost_bar: TextureProgressBar = $CanvasLayer/boostBar
@onready var shield_bar: TextureProgressBar = $CanvasLayer/shieldBar

@onready var progress_bar: TextureProgressBar = $CanvasLayer/progressBar

@onready var projectile_delete_bar: HBoxContainer = $CanvasLayer/projectileDeleteBar

@onready var player: CharacterBody2D = $Player

@onready var transition_manager = $".."



var score: float
var rescuedCount: int = 0

const SCORE_FOR_BOSS:float = 1500

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
	progress_bar.value = (score/SCORE_FOR_BOSS) * 100
	$CanvasLayer/progressBar/progressBarIcon.position.x = (128 * (score/SCORE_FOR_BOSS))
	
	if player.isBurntout:
		boost_bar.tint_progress = Color(0.2, 0.2, 0.2)
	else:
		boost_bar.tint_progress = Color.WHITE

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/scoreLabel.text = str(score) + "m"
	if score >= SCORE_FOR_BOSS:
		goToBoss()

func gameOver():
	var emRaft = $CanvasLayer/emergencyRaft
	player.set_physics_process(false)
	emRaft.position = player.position
	emRaft.visible = true
	player.visible = false
	emRaft.activateRaft()
	$CanvasLayer/emergencyRaft/emRaftTimer.start()
	await $CanvasLayer/emergencyRaft/emRaftTimer.timeout
	transition_manager.villageStart(score, rescuedCount)
	queue_free()

func goToBoss():
	transition_manager.bossFightStart(score, rescuedCount)
	queue_free()
