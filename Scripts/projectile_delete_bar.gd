extends HBoxContainer

@onready var projDeleterArray: Array

@export var maxProjDeletes: int
var maxProjectileDeleteValue: float = 100 #100 per use

var curProjDeleteValue = 0
var projDeleteRegenRate = 0.03 * maxProjDeletes
var curProjIndex
@onready var projDeleterSingularUI = preload("res://Scenes/proj_deleter_singular.tscn")

var playerStats = preload("res://Scenes/playerStats.tres")

func _ready() -> void:
	reload_page()
	maxProjDeletes = playerStats.numProjDeleters
	for a in range(maxProjDeletes):
		var p = projDeleterSingularUI.instantiate()
		add_child(p)
		projDeleterArray.append(p)
	curProjIndex = maxProjDeletes
	projDeleteRegenRate = 0.02 * maxProjDeletes
		
func _process(delta: float) -> void:
	updateProjDeleteBar()
	if curProjIndex <= maxProjDeletes - 1:
		if curProjDeleteValue + projDeleteRegenRate <= maxProjectileDeleteValue:
			curProjDeleteValue += projDeleteRegenRate
		else:
			curProjDeleteValue = 100
		if curProjDeleteValue >= 100:
			if curProjIndex <= maxProjDeletes - 1:
				curProjIndex += 1
				curProjDeleteValue = 0
	
func updateProjDeleteBar():
	var afterCurIndex = false
	var curIndex = 0
	for i in projDeleterArray:
		if curIndex == curProjIndex:
			i.value = curProjDeleteValue
			afterCurIndex = true
			i.get_node("glowEffect").visible = false
		else:
			if !afterCurIndex:
				i.value = 100
				i.get_node("glowEffect").visible = true
			else:
				i.value = 0
				i.get_node("glowEffect").visible = false
		curIndex += 1
		
func usedProjDeleter():
	curProjIndex -= 1
	
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
