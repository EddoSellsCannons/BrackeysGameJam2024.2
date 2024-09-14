extends Area2D

@export var projSpeed = 300
@export var damage = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += projSpeed * delta
