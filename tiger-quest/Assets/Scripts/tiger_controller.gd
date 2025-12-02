extends CharacterBody2D

@export var projectile_prefab: PackedScene
@export var projectile_offset: Vector2
@export var speed: float = 10.0
@export var jump_amount: float = 10
@export var coyote_time: float = 0.4
@export var falling_grav_mult: float = 2
@export var terminal_velocity: float = 1000
@export var jump_hold_time: float = 0.5
@export var jump_hold_amount: float = 10
@export var fire_cooldown: float = 1.5

const JUMPMOD: float = -30
const SPEEDMOD: float = 30

@onready var sprite_holder: Node2D = $Visuals
@onready var anim_sm: AnimationTree = $Visuals/AnimationTree

var did_jump: bool = false
var time_since_left_ground: float = 0
var is_airborn: bool = false
var jump_timer: float = 0
var fire_timer: float = 0

func _physics_process(delta: float) -> void:
	if(fire_timer > 0):
		fire_timer -= delta
	else:
		if Input.is_action_just_pressed("fire"):
			fire()
	
	is_airborn = !is_on_floor()
	if is_on_floor():
		time_since_left_ground = 0
		did_jump = false
	else:
		time_since_left_ground += delta
		var gravity_mod = 1
		if(velocity.y > 0):
			gravity_mod = falling_grav_mult
		velocity += get_gravity() * delta * gravity_mod
		if(velocity.y > terminal_velocity):
			velocity.y = terminal_velocity

	if Input.is_action_just_pressed("jump") and (is_on_floor() or 
	(!did_jump and time_since_left_ground < coyote_time)):
		did_jump = true
		velocity.y = jump_amount * JUMPMOD
		jump_timer = 0
	jump_timer += delta
	if (Input.is_action_pressed("jump") and jump_timer < jump_hold_time):
		velocity.y += jump_hold_amount * JUMPMOD * delta
	
	if (Input.is_action_pressed("move_down")):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)
	
	var direction := Input.get_axis("move_left", "move_right")
	if(direction != 0):
		set_dir(direction > 0)
	if direction:
		velocity.x = direction * speed * SPEEDMOD
	else:
		velocity.x = move_toward(velocity.x, 0, speed * SPEEDMOD)

	move_and_slide()


func set_dir(is_right: bool):
	sprite_holder.scale = Vector2((-1 if is_right else 1),1)

func fire():
	fire_timer = fire_cooldown
	#play sound
	#spawn prefab
	var offset_position: Vector2 = projectile_offset
	offset_position.x *= sprite_holder.scale.x
	var projectile: Node2D = projectile_prefab.instantiate()
	projectile.position = position + offset_position
	projectile.scale.x = -sprite_holder.scale.x
	get_parent().add_child(projectile)
