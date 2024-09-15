extends CharacterBody2D

signal usedProjDeleter

const BOOST_MULTIPLIER = 3

@onready var gameManager = $".."

@export var standardPlayerSpeed: float
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
var shieldPerRepairman: int = 2

var isBoosted: bool = false
var isRegen: bool = true
var isBurntout: bool = false
var isDeletingProj: bool = false

var isAffectedByWind: bool = false

@onready var main_sprite: AnimatedSprite2D = $mainSprite
@onready var armor: AnimatedSprite2D = $mainSprite/armor

var playerStats = preload("res://Scenes/playerStats.tres")

func _ready() -> void:
	reload_page()
	playerMaxHealth = playerStats.maxHealth
	playerCurHealth = playerMaxHealth
	
	playerMaxShield = playerStats.maxShield
	playerCurShield = playerMaxShield
	
	playerMaxStamina = playerStats.maxStamina
	playerCurStamina = playerMaxStamina
	
	staminaRegenAmount = playerStats.maxStamina/500
	
	standardPlayerSpeed = playerStats.standardSpeed
	playerSpeed = standardPlayerSpeed
	
	repairmanCount =  playerStats.numRepairman

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	applyBoost()
	position += dir * playerSpeed * delta
	if isAffectedByWind:
		position += Vector2(-100, 0) * delta
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
		$mainSprite/repairAnim.visible = true
	else:
		$mainSprite/repairAnim.visible = false
	if isBurntout:
		if playerCurStamina >= playerMaxStamina:
			isBurntout = false
	if playerCurHealth <= 0:
		gameOver()
	updatePlayerSprite()
	if Input.is_action_pressed("ui_cancel"):
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
	animation_player.play("takeDamage")
	gameManager.transition_manager.SFX.playTakeDamage()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		takeDamage(body.damage)
		if body.has_method("playInkSplatter"):
			body.playInkSplatter()
			await body.animation_player.animation_finished
		body.queue_free()
	if body.is_in_group("survivor"):
		rescuedSurvivor()
		body.queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		takeDamage(area.damage)

func projectileDeleteActivate():
	if gameManager.projectile_delete_bar.curProjIndex <= 0 or isDeletingProj:
		return
	isDeletingProj = true
	usedProjDeleter.emit()
	animation_player.play("projDeleteActivate")
	gameManager.transition_manager.SFX.playSafetyNet()
	await animation_player.animation_finished
	animation_player.play("RESET")
	isDeletingProj = false

func _on_proj_delete_aura_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		body.queue_free()

func applyBoost():
	if isBoosted:
		playerSpeed = standardPlayerSpeed * BOOST_MULTIPLIER
		$"../CanvasLayer/boosterEffect".visible = true
	else:
		playerSpeed = standardPlayerSpeed
		$"../CanvasLayer/boosterEffect".visible = false

func regenShield(delta):
	var shieldAmount = (repairmanCount * shieldPerRepairman) * delta
	if playerCurShield + shieldAmount > playerMaxShield:
		playerCurShield = playerMaxShield
	else:
		playerCurShield += shieldAmount

func rescuedSurvivor():
	gameManager.rescuedCount += 1
	gameManager.transition_manager.SFX.playPickupSurvivor()
	
func updatePlayerSprite():
	var curFrame = main_sprite.get_frame()
	if (playerCurHealth/playerMaxHealth) * 100 >= 60: #More than 60%, default
		main_sprite.play("default")
	elif (playerCurHealth/playerMaxHealth) * 100 >= 25:
		main_sprite.play("worn")
	else:
		main_sprite.play("damaged")
	
	if (playerCurShield/playerMaxShield) * 100 >= 60: #More than 60%, default
		armor.play("default")
		armor.visible = true
	elif (playerCurShield/playerMaxShield) * 100 >= 25:
		armor.play("worn")
		armor.visible = true
	elif (playerCurShield/playerMaxShield) * 100 > 0:
		armor.play("damaged")
		armor.visible = true
	else:
		armor.visible = false
	armor.set_frame(curFrame)

func gameOver():
	gameManager.gameOver()

func affectedByWind(isAffected: bool):
	if isAffected:
		isAffectedByWind = true
	else:
		isAffectedByWind = false

func save():
	var save_dict = {
		"filename": get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict

func reload_page():
	playerStats = get_tree().root.get_node("transitionManager").playerStats
	playerMaxHealth = playerStats.maxHealth
	playerCurHealth = playerMaxHealth
	
	playerMaxShield = playerStats.maxShield
	playerCurShield = playerMaxShield
	
	playerMaxStamina = playerStats.maxStamina
	playerCurStamina = playerMaxStamina
	
	staminaRegenAmount = playerStats.maxStamina/500
	
	standardPlayerSpeed = playerStats.standardSpeed
	playerSpeed = standardPlayerSpeed
	
	repairmanCount =  playerStats.numRepairman
