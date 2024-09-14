extends Control

@onready var villageManager = $"../.."

@onready var curPlayerStats = preload("res://Scenes/playerStats.tres")

#Currently unused
var maxHealth
var maxShield
var maxStamina
var standardSpeed
var numProjDeleters
#var numRepairman
# ^^ Currently unused

var upgradeAmount = 10

var maxHealthUpgradeCost:int = 200
var maxShieldUpgradeCost:int = 50
var maxStaminaUpgradeCost:int = 50
var speedUpgradeCost:int = 100
var projDeleterUpgradeCost:int = 150

var costMultiplier = 1.25

var SAFETY_NET_LIMIT = 10

func _ready() -> void:
	#Currently redundant
	maxHealth = curPlayerStats.maxHealth
	maxShield = curPlayerStats.maxShield
	maxStamina = curPlayerStats.maxStamina
	standardSpeed = curPlayerStats.standardSpeed
	numProjDeleters = curPlayerStats.numProjDeleters
	
func _process(delta: float) -> void:
	$NinePatchRect/MaxHP/buyMaxHPUpgrade.text = str(maxHealthUpgradeCost)
	$NinePatchRect/MaxShield/buyMaxShieldUpgrade.text = str(maxShieldUpgradeCost)
	$NinePatchRect/stamina/buyStaminaUpgrade.text = str(maxStaminaUpgradeCost)
	$NinePatchRect/speed/buySpeedUpgrade.text = str(speedUpgradeCost)
	if curPlayerStats.numProjDeleters >= 10:
		$NinePatchRect/projDeleter/buyprojDeleterUpgrade.text = "MAX"
	else:
		$NinePatchRect/projDeleter/buyprojDeleterUpgrade.text = str(projDeleterUpgradeCost)

func upgradeHealth():
	if villageManager.numWood >= maxHealthUpgradeCost:
		villageManager.numWood -= maxHealthUpgradeCost
		curPlayerStats.maxHealth += upgradeAmount * 2
		maxHealthUpgradeCost *= costMultiplier
		
func upgradeShields():
	if villageManager.numWood >= maxShieldUpgradeCost:
		villageManager.numWood -= maxShieldUpgradeCost
		curPlayerStats.maxShield += upgradeAmount
		maxShieldUpgradeCost *= costMultiplier
		
func upgradeStamina():
	if villageManager.numWood >= maxStaminaUpgradeCost:
		villageManager.numWood -= maxStaminaUpgradeCost
		curPlayerStats.maxStamina += upgradeAmount
		maxStaminaUpgradeCost *= costMultiplier
		
func upgradeSpeed():
	if villageManager.numWood >= speedUpgradeCost:
		villageManager.numWood -= speedUpgradeCost
		curPlayerStats.standardSpeed += upgradeAmount * 3
		speedUpgradeCost *= costMultiplier
		
func upgradeProjDeleter():
	if curPlayerStats.numProjDeleters >= 10:
		return
	if villageManager.numWood >= projDeleterUpgradeCost:
		villageManager.numWood -= projDeleterUpgradeCost
		curPlayerStats.numProjDeleters += 1
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
