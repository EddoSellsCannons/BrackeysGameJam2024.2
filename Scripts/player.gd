extends CharacterBody2D

@export var playerSpeed: float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += dir * playerSpeed * delta
	move_and_slide()

func takeDamage():
	print("Dmg")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		takeDamage()
		body.queue_free()
