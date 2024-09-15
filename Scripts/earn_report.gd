extends Control

@onready var wood_label: Label = $NinePatchRect/wood/woodLabel
@onready var food_label: Label = $NinePatchRect/food/foodLabel
@onready var volunteer_label: Label = $NinePatchRect/wood3/volunteerLabel

func _ready() -> void:
	visible = false

func updateReport(wood, food, survivors):
	wood_label.text = "+" + str(int(wood)) + " wood chopped"
	food_label.text = "+" + str(int(food)) + " food fished"
	volunteer_label.text = "+" + str(survivors) + " volunteers rescued"
	visible = true

func _on_close_button_button_down() -> void:
	visible = false
