extends HBoxContainer

@onready var projDeleterArray = [$projDeleter, $projDeleter2, $projDeleter3, $projDeleter4, $projDeleter5]

@export var maxProjDeletes: int = 5
var maxProjectileDeleteValue: float = maxProjDeletes * 100 #100 per use

var curProjDeleteValue = 0
var projDeleteRegenRate = 0.2
var curProjIndex = maxProjDeletes - 1

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
