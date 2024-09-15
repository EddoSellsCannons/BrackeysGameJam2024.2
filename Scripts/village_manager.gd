extends Node2D

@onready var curPlayerStats = preload("res://Scenes/playerStats.tres")

var numWood:int = 0
var woodEarningRate = 0

var numFood:int = 200
var foodEarningRate = 0

var numPopulation = 5

var numLumberjack = 0
var costLumberjack:int = 30
var woodPerLumberjack = 2

var numFisherman = 5
var costFisherman:int = 20
var foodPerFisherman = 3

var numRepairman = 0
var costRepairman:int = 100

var costIncreaseMultiplier = 1.05
var scoreMultiplier:float = 0.02 #every x metres, gets 1 rate of resource (50 for now)

@onready var wood_count: Label = $CanvasLayer/woodUI/woodCount
@onready var food_count: Label = $CanvasLayer/foodUI/foodCount
@onready var pop_count: Label = $CanvasLayer/popUI/popCount

@onready var lumberjack_count: Label = $forest/lumberjackCount
@onready var fisherman_count: Label = $fisherman/fishermanCount
@onready var repairman_count: Label = $repairman/repairmanCount

@onready var shipyard_menu: Control = $CanvasLayer/shipyardMenu

@onready var transition_manager: Node2D = $".."

func _ready() -> void:
	$boat/skipToBoss.visible = false
	foodEarningRate = foodPerFisherman * numFisherman
	woodEarningRate = woodPerLumberjack * numLumberjack

func _process(delta: float) -> void:
	wood_count.text = "Wood: " + str(numWood)
	food_count.text = "Food: " + str(numFood)
	pop_count.text = "Volunteers: " + str(numPopulation)
	
	lumberjack_count.text = "Lumberjacks: " + str(numLumberjack)
	fisherman_count.text = "Fisherman: " + str(numFisherman)
	repairman_count.text = "Repairman: " + str(curPlayerStats.numRepairman)
	
	$forest/addLumberjack.text = "Assign Lumberjack:\n" + str(costLumberjack) + " food"
	$fisherman/addFisherman.text = "Assign Fisherman:\n" + str(costFisherman) + " food"
	$repairman/addRepairman.text = "Assign Repairman:\n" + str(costRepairman) + " food"

func addLumberjack():
	if numFood >= costLumberjack and numPopulation >= 1:
		numFood -= costLumberjack
		numLumberjack += 1
		numPopulation -= 1
		costLumberjack *= costIncreaseMultiplier
		woodEarningRate = numLumberjack * woodPerLumberjack
		
func addFisherman():
	if numFood >= costFisherman and numPopulation >= 1:
		numFood -= costFisherman
		numFisherman += 1
		numPopulation -= 1
		costFisherman *= costIncreaseMultiplier
		foodEarningRate = numFisherman * foodPerFisherman
		
func addRepairman():
	if numFood >= costRepairman and numPopulation >= 1:
		numFood -= costRepairman
		curPlayerStats.numRepairman += 1
		numPopulation -= 1
		costRepairman *= costIncreaseMultiplier

func _on_add_lumberjack_button_down() -> void:
	addLumberjack()

func _on_add_fisherman_button_down() -> void:
	addFisherman()

func _on_add_repairman_button_down() -> void:
	addRepairman()

func _on_shipyard_menu_button_down() -> void:
	shipyard_menu.visible = true

func _on_start_game_button_down() -> void:
	transition_manager.gameStart()

func _on_close_menu_button_down() -> void:
	shipyard_menu.visible = false

func hideVillage():
	visible = false
	$CanvasLayer.visible = false
	$AudioStreamPlayer.stop()

func showVillage():
	visible = true
	$CanvasLayer.visible = true
	$AudioStreamPlayer.play()
	if transition_manager.hasSeenBoss:
		$boat/skipToBoss.visible = true
	else:
		$boat/skipToBoss.visible = false

func earnResources(score, rescuedCount):
	numWood += score * scoreMultiplier * woodEarningRate
	numFood += score * scoreMultiplier * foodEarningRate
	numPopulation += rescuedCount
	$CanvasLayer/earnReport.updateReport(score * scoreMultiplier * woodEarningRate, score * scoreMultiplier * foodEarningRate, rescuedCount)

func _on_skip_to_boss_button_down() -> void:
	hideVillage()
	transition_manager.bossFightStart(0, 0)

func save():
	var save_dict = {
		"filename": get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y, 
		"numWood": numWood,
		"woodEarningRate": woodEarningRate,
		"numFood": numFood,
		"foodEarningRate": foodEarningRate,
		"numPopulation": numPopulation,
		"numLumberjack": numLumberjack,
		"costLumberjack": costLumberjack,
		"woodPerLumberjack": woodPerLumberjack,
		"numFisherman": numFisherman,
		"costFisherman": costFisherman,
		"foodPerFisherman": foodPerFisherman,
		"numRepairman": numRepairman,
		"costRepairman": costRepairman
	}
	return save_dict
