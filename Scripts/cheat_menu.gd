extends Control

@onready var village_manager = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_cheats_button_down() -> void:
	visible = true

func _on_wood_button_button_down() -> void:
	village_manager.numWood += 100

func _on_food_button_button_down() -> void:
	village_manager.numFood += 100

func _on_volunteer_button_button_down() -> void:
	village_manager.numPopulation += 10

func _on_boss_unlock_button_down() -> void:
	village_manager.transition_manager.hasSeenBoss = true
	$"../../../boat/skipToBoss".visible = true
