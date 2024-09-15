extends RigidBody2D

var speed = 200

@onready var destination_marker: Marker2D = $"../destinationMarker"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (destination_marker.global_position - global_position).normalized() * speed * delta
