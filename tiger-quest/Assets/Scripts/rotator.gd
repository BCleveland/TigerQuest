extends Node2D

@export var speed = 1

func _process(delta: float) -> void:
	rotation_degrees += speed * delta
