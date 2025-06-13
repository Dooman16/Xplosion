extends Area2D

@export var projectile : PackedScene
@onready var body := $hitbox

const MAX_RETRACTION_DISTANCE := 20
const MAX_ATTACK_RANGE := 45
const CHARGING_TIME := 1.5
const HOOK_CHARGING_TIME := 3
const MAX_DISTANCE_PER_SPEED := 1
const ATTACK_COOLDOWN := 1.2
const MELEE_ATTACK_CHARGING_TIME := 0.1
const DIRECTION := Vector2(1, 0)
const STARTING_POS = Vector2(22.5,0)

var charge := 0.0
var speed := 0.0
var meleeing := false
var charged := false
var thrown := false

func _ready():
	# Conectar señales del área de colisión
	body.connect("area_entered", Callable(self, "_on_area_entered"))
	body.connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	if speed == 0:
		if Input.is_action_pressed("left_attack"):
			charge_range_attack(delta)
		elif Input.is_action_just_released("left_attack"):
			release_range_attack()
		if Input.is_action_pressed("right_attack"):
			meleeing = true
	else:
		move(delta)

	if meleeing:
		melee_attack(delta)

func charge_range_attack(delta: float):
	if charge <= MAX_RETRACTION_DISTANCE:
		charge += delta * MAX_RETRACTION_DISTANCE / CHARGING_TIME
		body.position = STARTING_POS - charge*DIRECTION
	else:
		charge = MAX_RETRACTION_DISTANCE
		body.position = STARTING_POS - (charge - (randf() * 2 - 1))*DIRECTION

	global_rotation = get_xplosion_rotation()

func release_range_attack():
	speed = charge * 30
	charge = 0.0

func melee_attack(delta: float):
	const MELEE_SPEED = MAX_RETRACTION_DISTANCE / MELEE_ATTACK_CHARGING_TIME
	global_rotation = get_xplosion_rotation()

	var distance_to_start = (body.position - STARTING_POS).length()

	if distance_to_start <= MAX_RETRACTION_DISTANCE / 2 and not charged:
		body.position -= delta * MELEE_SPEED*DIRECTION
	elif distance_to_start <= MAX_ATTACK_RANGE and not thrown:
		charged = true
		body.position += delta * MELEE_SPEED*DIRECTION
	elif distance_to_start > 1:
		body.position -= delta * MELEE_SPEED*DIRECTION
		thrown = true
	else:
		body.position = STARTING_POS
		charged = false
		thrown = false
		meleeing = false

func move(delta: float):
	body.position += DIRECTION * speed * delta
	var distance_covered = (body.position - STARTING_POS).length()

	if speed > 0:
		if distance_covered >= MAX_DISTANCE_PER_SPEED * speed:
			return_lance()
	elif speed < 0:
		if distance_covered < 1:
			body.position = STARTING_POS
			speed = 0
			body.disabled = false

func return_lance():
	print("hello")
	body.disabled = true
	var distance_covered = (body.position - STARTING_POS).length()
	speed = -distance_covered / ATTACK_COOLDOWN

func get_xplosion_rotation() -> float:
	var vectorial_difference = get_mouse_vectorial_difference()
	return atan2(vectorial_difference.y, vectorial_difference.x)

func get_mouse_vectorial_difference() -> Vector2:
	return get_global_mouse_position() - global_position

func _on_area_entered(area: Area2D) -> void:
	if speed > 0:
		return_lance()

func _on_body_entered(body_node: Node2D) -> void:
	if speed > 0:
		return_lance()

func charge_hook():
	pass

func release_hook():
	pass
