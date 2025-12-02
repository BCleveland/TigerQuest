extends Node2D

@export var max_speed: float = 500
@export var speed_curve: Curve
@export var total_lifetime: float = 0.4

var lifetime: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta
	var current_speed_mod = speed_curve.sample(lifetime/total_lifetime)
	var dir: float = scale.x
	position.x += max_speed * current_speed_mod * dir * delta
	if(lifetime > total_lifetime):
		queue_free()	
