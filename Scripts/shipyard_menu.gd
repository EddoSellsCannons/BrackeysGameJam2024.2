extends Control

@onready var villageManager = $"../.."

var playerStats = preload("res://Scenes/playerStats.tres")

var upgradeAmount = 10

var maxHealthUpgradeCost:int = 200
var maxShieldUpgradeCost:int = 50
var maxStaminaUpgradeCost:int = 50
var speedUpgradeCost:int = 100
var projDeleterUpgradeCost:int = 150

var costMultiplier = 1.25

var SAFETY_NET_LIMIT = 10

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	$NinePatchRect/MaxHP/buyMaxHPUpgrade.text = str(maxHealthUpgradeCost)
	$NinePatchRect/MaxShield/buyMaxShieldUpgrade.text = str(maxShieldUpgradeCost)
	$NinePatchRect/stamina/buyStaminaUpgrade.text = str(maxStaminaUpgradeCost)
	$NinePatchRect/speed/buySpeedUpgrade.text = str(speedUpgradeCost)
	if playerStats.numProjDeleters >= 10:
		$NinePatchRect/projDeleter/buyprojDeleterUpgrade.text = "MAX"
	else:
		$NinePatchRect/projDeleter/buyprojDeleterUpgrade.text = str(projDeleterUpgradeCost)

func upgradeHealth():
	if villageManager.numWood >= maxHealthUpgradeCost:
		villageManager.numWood -= maxHealthUpgradeCost
		playerStats.maxHealth += upgradeAmount * 2
		maxHealthUpgradeCost *= costMultiplier
		
func upgradeShields():
	if villageManager.numWood >= maxShieldUpgradeCost:
		villageManager.numWood -= maxShieldUpgradeCost
		playerStats.maxShield += upgradeAmount
		maxShieldUpgradeCost *= costMultiplier
		
func upgradeStamina():
	if villageManager.numWood >= maxStaminaUpgradeCost:
		villageManager.numWood -= maxStaminaUpgradeCost
		playerStats.maxStamina += upgradeAmount
		maxStaminaUpgradeCost *= costMultiplier
		
func upgradeSpeed():
	if villageManager.numWood >= speedUpgradeCost:
		villageManager.numWood -= speedUpgradeCost
		playerStats.standardSpeed += upgradeAmount * 3
		speedUpgradeCost *= costMultiplier
		
func upgradeProjDeleter():
	if playerStats.numProjDeleters >= 10:
		return
	if villageManager.numWood >= projDeleterUpgradeCost:
		villageManager.numWood -= projDeleterUpgradeCost
		playerStats.numProjDeleters += 1
		projDeleterUpgradeCost *= costMultiplier

func _on_buy_max_hp_upgrade_button_down() -> void:
	upgradeHealth()

func _on_buy_max_shield_upgrade_button_down() -> void:
	upgradeShields()

func _on_buy_stamina_upgrade_button_down() -> void:
	upgradeStamina()

func _on_buy_speed_upgrade_button_down() -> void:
	upgradeSpeed()

func _on_buyproj_deleter_upgrade_button_down() -> void:
	upgradeProjDeleter()

func save():
	var save_dict = {
		"filename": get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y, 
		"maxHealthUpgradeCost": maxHealthUpgradeCost,
		"maxShieldUpgradeCost": maxShieldUpgradeCost,
		"maxStaminaUpgradeCost": maxStaminaUpgradeCost,
		"speedUpgradeCost": speedUpgradeCost,
		"projDeleterUpgradeCost": projDeleterUpgradeCost
	}
	return save_dict
	
func reload_page():
	playerStats = villageManager.transition_manager.playerStats

func _on_close_menu_button_down() -> void:
	visible = false
