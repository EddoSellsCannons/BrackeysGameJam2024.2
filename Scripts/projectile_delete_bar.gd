extends HBoxContainer

@onready var projDeleterArray: Array

@export var maxProjDeletes: int
var maxProjectileDeleteValue: float = 100 #100 per use

var curProjDeleteValue = 0
var projDeleteRegenRate = 0.2
var curProjIndex
@onready var projDeleterSingularUI = preload("res://Scenes/proj_deleter_singular.tscn")

func _ready() -> void:
	for a in range(maxProjDeletes):
		var p = projDeleterSingularUI.instantiate()
		add_child(p)
		projDeleterArray.append(p)
	curProjIndex = maxProjDeletes
		
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
	print(curProjIndex)
	
func updateProjDeleteBar():
	var afterCurIndex = false
	var curIndex = 0
	for i in projDeleterArray:
		if curIndex == curProjIndex:
			i.value = curProjDeleteValue
			afterCurIndex = true
			i.modulate = Color.WHITE
		else:
			if !afterCurIndex:
				i.value = 100
				i.modulate = Color.GREEN
			else:
				i.value = 0
				i.modulate = Color.WHITE
		curIndex += 1
		
func usedProjDeleter():
	curProjIndex -= 1
