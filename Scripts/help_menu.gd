extends Control

var pageArray: Array
var pageIndex = 0

var hasOpened: bool = false

@onready var animation_player: AnimationPlayer = $"../helpButton/AnimationPlayer"

func _ready() -> void:
	pageArray = [$NinePatchRect/Lore_Intro, $NinePatchRect/Controls, $NinePatchRect/outpostPage1, $NinePatchRect/outpostPage2, $NinePatchRect/oceanPage1, $NinePatchRect/oceanPage2, $NinePatchRect/oceanPage3, $NinePatchRect/oceanPage4]
	visible = false
	var i = 0
	for p in pageArray:
		if i == pageIndex:
			p.visible = true
		else:
			p.visible = false
		i += 1
	if !hasOpened:
		animation_player.play("glow")
	else:
		animation_player.play("RESET")
	
func _on_close_help_menu_button_down() -> void:
	visible = false

func _on_help_button_button_down() -> void:
	visible = true
	hasOpened = true
	animation_player.play("RESET")

func _on_next_page_button_down() -> void:
	pageIndex += 1
	pageIndex = fmod(pageIndex, pageArray.size())
	var i = 0
	for p in pageArray:
		if i == pageIndex:
			p.visible = true
		else:
			p.visible = false
		i += 1

func _on_prev_page_button_down() -> void:
	pageIndex -= 1
	if pageIndex < 0:
		pageIndex = pageArray.size() - 1
	var i = 0
	for p in pageArray:
		if i == pageIndex:
			p.visible = true
		else:
			p.visible = false
		i += 1

func save():
	var save_dict = {
		"filename": get_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y, 
		"hasOpened": hasOpened 
	}
	return save_dict
