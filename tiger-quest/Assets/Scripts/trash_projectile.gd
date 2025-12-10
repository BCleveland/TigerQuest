extends Node2D

@export var Speed: float = 400
@export var MaxVerticalDistance: float = 150
@export var VerticalOffset: float = -25

var targetHeight: float = 0
var travelRight: bool
var travelUp: bool

func initialize(playerPos: Vector2):
	position.y += VerticalOffset
	targetHeight = max(position.y-MaxVerticalDistance, 
	min(position.y+MaxVerticalDistance, playerPos.y)) + VerticalOffset
	travelRight = playerPos.x > position.x
	travelUp = playerPos.y < position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(travelRight):
		position.x += Speed * delta
	else:
		position.x -= Speed * delta
	if(travelUp && position.y > targetHeight):
		position.y -= Speed * delta
	elif (!travelUp && position.y < targetHeight):
		position.y += Speed * delta
