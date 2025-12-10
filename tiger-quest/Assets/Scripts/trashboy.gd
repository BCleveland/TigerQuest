extends Node2D

@export var ProjectilePrefab: PackedScene
@export var SwitchTime: float = 2

@onready var anim: AnimationPlayer = $AnimationPlayer

var switch_timer: float = 0
var is_raised: bool = false

var overlappingBody: Node2D

func _ready() -> void:
	anim.play("stay_low")

func _process(delta: float) -> void:
	switch_timer += delta
	if(switch_timer > SwitchTime):
		switch_timer = 0
		is_raised = !is_raised
		if(is_raised):
			anim.play("raise")
		else:
			anim.play("lower")

func _on_monitor_zone_body_entered(body: Node2D) -> void:
	if(overlappingBody != null):
		printerr("Trashboy overlapped with second body")
		return
	overlappingBody = body
	#begin popping out animation
	#after it finishes, throw projectile
	#wait
	#close animation

func fireProjectile():
	if(overlappingBody != null):
		var projectile: Node2D = ProjectilePrefab.instantiate()
		projectile.position = position
		get_parent().call_deferred("add_child", projectile)
		projectile.initialize(overlappingBody.position)


func _on_monitor_zone_body_exited(body: Node2D) -> void:
	if(overlappingBody == body):
		overlappingBody = null
	else:
		printerr("TrashBoy had non saved body leave")
