extends Node2D

@onready var game_manager = preload("res://Scenes/gameManager.tscn")
@onready var boss_fight_manager = preload("res://Scenes/bossFightManager.tscn")
@onready var village_manager: Node2D = $villageManager


func _ready() -> void:
	pass

func gameStart():
	var g = game_manager.instantiate()
	add_child(g)
	village_manager.hideVillage()
	
func villageStart(score, rescuedCount):
	village_manager.showVillage()
	village_manager.earnResources(score, rescuedCount)

func bossFightStart(score, rescuedCount):
	village_manager.earnResources(score, rescuedCount)
	var b = boss_fight_manager.instantiate()
	add_child(b)
