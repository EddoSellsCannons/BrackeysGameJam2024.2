extends Node2D

@onready var animation_player: AnimationPlayer = $"../eventsAnim"

var bossMaxHealth = 200
var bossHealth: float = 200

var eventsArray:Array = ["affectedByWind", "cameraRocking", "inkDebuff", "lightningStrikes"]
var prevEventHealth = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fmod(bossHealth, 20) == 0 and prevEventHealth != bossHealth and bossHealth != 0:
		prevEventHealth = bossHealth
		animation_player.play(eventsArray.pick_random())

func takeDamage(damageTaken):
	if bossHealth - damageTaken >= 0:
		bossHealth -= damageTaken
	else:
		visible = false
		set_process(false)
		$"..".playWin()
		#play death anim

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerProj"):
		takeDamage(area.damage)
		area.queue_free()
