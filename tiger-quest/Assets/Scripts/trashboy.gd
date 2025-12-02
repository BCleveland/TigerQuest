extends Node2D

@export var switch_time: float = 2

@onready var anim: AnimationPlayer = $AnimationPlayer

var switch_timer: float = 0
var is_raised: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("stay_low")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	switch_timer += delta
	if(switch_timer > switch_time):
		switch_timer = 0
		is_raised = !is_raised
		if(is_raised):
			anim.play("raise")
		else:
			anim.play("lower")
