extends Node2D

@export var ProjectilePrefab: PackedScene
@export var RaiseTime: float = 0.5
@export var LowerSpriteHeight: float = 120
@export var InitialFireDelay: float = 0.5
@export var FireTime: float = 3.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var faceSprite: Sprite2D = $Scalar/Face
@onready var hatSprite: Sprite2D = $Scalar/Hat

var raisePercent: float = 0
var fireTimer: float = 0

var overlappingBody: Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if overlappingBody != null:
		fireTimer -= delta
		if(fireTimer <= 0):
			fireProjectile()
		if(raisePercent < 1):
			raisePercent += 1/RaiseTime*delta
		if overlappingBody.position.x > position.x:
			faceSprite.scale.x = -1
		else:
			faceSprite.scale.x = 1
	else:
		if(fireTimer > InitialFireDelay):
			fireTimer -= delta
		if(raisePercent > 0):
			raisePercent -= 1/RaiseTime*delta
	faceSprite.position.y = lerpf(LowerSpriteHeight, 0, raisePercent)
	hatSprite.position.y = lerpf(LowerSpriteHeight, 0, raisePercent)

func _on_monitor_zone_body_entered(body: Node2D) -> void:
	if(overlappingBody != null):
		printerr("Trashboy overlapped with second body")
		return
	overlappingBody = body
	if(fireTimer < InitialFireDelay):
		fireTimer = InitialFireDelay
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
		fireTimer = FireTime


func _on_monitor_zone_body_exited(body: Node2D) -> void:
	if(overlappingBody == body):
		overlappingBody = null
	else:
		printerr("TrashBoy had non saved body leave")
