extends Area2D

@export var projectile : PackedScene
@onready var attackCooldown := $attackCooldown
@onready var melee_range := $melee_range
@onready var mouse_positon := mouse

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_attack"):
		if melee_range:
			melee_attack()
		else:
			range_attack()
	if event.is_action_pressed("right_attack"):
		hook()
		
func range_attack():
	pass
func melee_attack():
	pass
func hook():
	pass
