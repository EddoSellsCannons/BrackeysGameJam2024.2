extends CharacterBody2D

signal usedProjDeleter

const BOOST_MULTIPLIER = 3

@onready var gameManager = $".."

@export var standardPlayerSpeed: float = 200
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var regen_stopped: Timer = $regenStopped

var playerSpeed = standardPlayerSpeed

var playerMaxHealth: float = 50
var playerCurHealth:float = playerMaxHealth

var playerMaxShield: float = 30
var playerCurShield:float = playerMaxShield

var playerMaxStamina: float = 100
var playerCurStamina:float = playerMaxStamina
var staminaRegenAmount = 0.3

var repairmanCount: int = 1
var shieldPerRepairman: int = 1

var isBoosted: bool = false
var isRegen: bool = true
var isBurntout: bool = false
var isDeletingProj: bool = false

func _ready() -> void:
	var curPlayerStats = load("res://Scenes/playerStats.tres")
	playerMaxHealth = curPlayerStats.maxHealth
	playerCurHealth = playerMaxHealth
	
	playerMaxShield = curPlayerStats.maxShield
	playerCurShield = playerMaxShield
	
	playerMaxStamina = curPlayerStats.maxStamina
	playerCurStamina = playerMaxStamina
	
	staminaRegenAmount = curPlayerStats.maxStamina/500
	
	repairmanCount =  curPlayerStats.numRepairman

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	applyBoost()
	position += dir * playerSpeed * delta
	move_and_slide()
	if Input.is_action_pressed("ui_accept"):
		projectileDeleteActivate()
	if Input.is_action_pressed("boost"):
		if !isBurntout:
			if playerCurStamina >= 0:
				isBoosted = true
				playerCurStamina -= 1
			else:
				isBurntout = true
				isBoosted = false
	else:
		isBoosted = false
	if playerCurStamina + staminaRegenAmount < playerMaxStamina:
		playerCurStamina += staminaRegenAmount
	else:
		playerCurStamina = playerMaxStamina
	if regen_stopped.is_stopped() == true:
		regenShield(delta)
	if isBurntout:
		if playerCurStamina >= playerMaxStamina:
			isBurntout = false
	if playerCurHealth <= 0:
		gameOver()

func takeDamage(damageTaken):
	if playerCurShield >= 0:
		if playerCurShield - damageTaken < 0:
			playerCurHealth -= damageTaken - playerCurShield
			playerCurShield = 0
		else:
			playerCurShield -= damageTaken
	else:
		playerCurHealth -= damageTaken
	regen_stopped.start()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		takeDamage(body.damage)
		body.queue_free()
	if body.is_in_group("survivor"):
		rescuedSurvivor()
		body.queue_free()

func projectileDeleteActivate():
	if gameManager.projectile_delete_bar.curProjIndex <= 0 or isDeletingProj:
		return
	isDeletingProj = true
	usedProjDeleter.emit()
	animation_player.play("projDeleteActivate")
	await animation_player.animation_finished
	animation_player.play("RESET")
	isDeletingProj = false

func _on_proj_delete_aura_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		body.queue_free()

func applyBoost():
	if isBoosted:
		playerSpeed = standardPlayerSpeed * BOOST_MULTIPLIER
	else:
		playerSpeed = standardPlayerSpeed

func regenShield(delta):
	var shieldAmount = (repairmanCount * shieldPerRepairman) * delta
	if playerCurShield + shieldAmount > playerMaxShield:
		playerCurShield = playerMaxShield
	else:
		playerCurShield += shieldAmount

func rescuedSurvivor():
	gameManager.rescuedCount += 1

func gameOver():
	gameManager.gameOver()
