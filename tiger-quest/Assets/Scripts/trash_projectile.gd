extends Node2D

@export var Speed: float = 400
@export var Lifetime: float = 3
@export var MaxVerticalDistance: float = 150
@export var VerticalOffset: float = -25

var targetHeight: float = 0
var travelRight: bool
var travelUp: bool
var timeLived: float = 0

func initialize(playerPos: Vector2):
	position.y += VerticalOffset
	targetHeight = max(position.y-MaxVerticalDistance, 
	min(position.y+MaxVerticalDistance, playerPos.y)) + VerticalOffset
	travelRight = playerPos.x > position.x
	travelUp = playerPos.y < position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeLived+=delta
	if(timeLived > Lifetime):
		queue_free()
	if(travelRight):
		position.x += Speed * delta
	else:
		position.x -= Speed * delta
	if(travelUp && position.y > targetHeight):
		position.y -= Speed * delta
	elif (!travelUp && position.y < targetHeight):
		position.y += Speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.TakeDamage(self, 1, true)
	queue_free()
