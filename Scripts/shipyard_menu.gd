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

var maxHealthUpgradeCost:int = 150
var maxShieldUpgradeCost:int = 50
var maxStaminaUpgradeCost:int = 50
var speedUpgradeCost:int = 100
var projDeleterUpgradeCost:int = 1

var costMultiplier = 1.1

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
	$NinePatchRect/projDeleter/buyprojDeleterUpgrade.text = str(projDeleterUpgradeCost)

func upgradeHealth():
	if villageManager.numWood >= maxHealthUpgradeCost:
		villageManager.numWood -= maxHealthUpgradeCost
		curPlayerStats.maxHealth += upgradeAmount
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
		curPlayerStats.standardSpeed += upgradeAmount
		speedUpgradeCost *= costMultiplier
		
func upgradeProjDeleter():
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
