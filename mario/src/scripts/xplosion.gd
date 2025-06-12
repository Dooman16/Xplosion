extends Area2D

@export var projectile : PackedScene
@onready var melee_range := $melee_range

const MAX_RETRACTION_DISTANCE := 20
const MAX_ATTACK_RANGE := 45
const CHARGING_TIME := 1.5
const HOOK_CHARGING_TIME := 3
const MAX_DISTANCE_PER_SPEED := 1
const ATTACK_COOLDOWN := 1.2
const MELEE_ATTACK_CHARGING_TIME := 0.1

var direction := Vector2(1,0)
var charge := 0.0
var starting_pos : Vector2
var speed := 0.0
var distance_coverd := 0.0
var meleeing := false
var charged := false
var thrown := false
var last_position := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if speed == 0:
		if Input.is_action_just_pressed("left_attack"):
			starting_pos = position
		if Input.is_action_pressed("left_attack"):
			if melee_range.is_colliding() and charge == 0:
				meleeing = true
			else:
				charge_range_attack(delta)
		elif Input.is_action_just_released("left_attack"):
			release_range_attack()
		if Input.is_action_pressed("right_attack"):
			charge_hook()
		elif Input.is_action_just_released("right_attack"):
			release_hook()
	else:
		move(delta)
	if meleeing:
		melee_attack(delta)
	last_position = position

func charge_range_attack(delta: float):
	direction = get_mouse_vectorial_difference().normalized()
	if MAX_RETRACTION_DISTANCE >= charge:
		charge += delta*MAX_RETRACTION_DISTANCE / CHARGING_TIME
		position = starting_pos - charge*direction
	else:
		charge = MAX_RETRACTION_DISTANCE
		position = starting_pos - (charge - (randf()*2 -1))*direction
	rotation = get_xplosion_rotation()
func release_range_attack():
	speed = charge*30
	charge = 0.0
	
func melee_attack(delta: float):
	const MELEE_SPEED = MAX_RETRACTION_DISTANCE / MELEE_ATTACK_CHARGING_TIME
	direction = get_mouse_vectorial_difference().normalized()
	if MAX_RETRACTION_DISTANCE/2 >= position.length() and not charged:
		position -= direction*delta*MELEE_SPEED
	elif MAX_ATTACK_RANGE >= position.length() and not thrown:
		charged = true
		position += direction*delta*MELEE_SPEED
	elif position.length() > 1 :
		position -= direction*delta*MELEE_SPEED
		thrown = true
	else:
		position = starting_pos
		charged = false
		thrown = false
		meleeing = false
	rotation = get_xplosion_rotation()
func charge_hook():
	pass
func release_hook():
	pass
	
func get_xplosion_rotation():
	var vectorial_diference = get_mouse_vectorial_difference()
	return atan2(vectorial_diference.y,vectorial_diference.x)
	
func get_mouse_vectorial_difference() -> Vector2:
	return get_global_mouse_position()-global_position

func _on_area_entered(area: Area2D) -> void:
	if speed > 0:
		return_lance()
		
func _on_body_entered(body: Node2D) -> void:
	if speed > 0:
		return_lance()

func move(delta: float):
	position += direction*speed*delta
	if speed > 0:
		distance_coverd = position.length()
		if distance_coverd >= MAX_DISTANCE_PER_SPEED*speed:
			return_lance()
	elif speed < 0:
		if position.length() > last_position.length():
			position = Vector2.ZERO
			speed = 0
			$CollisionShape2D.disabled = false

func return_lance():
	print("hello")
	$CollisionShape2D.disabled = true
	speed = (-1)*(distance_coverd / ATTACK_COOLDOWN)
	#position = Vector2.ZERO
