extends Node

@export var MAX_LIFE : int #no se deberia modificar
@onready var life : int = MAX_LIFE

var managable_entity : Node2D

@export var MAX_CORE_HIT_AMOUNT : int
@onready var core_hit_amount : int = MAX_CORE_HIT_AMOUNT

func what_to_do_if_you_get_hit(type,damage,origin):
	var x_diference = managable_entity.global_position.x - origin.x
	var knockback_direction = x_diference/abs(x_diference)
	managable_entity.disable_hitbox(knockback_direction)
	if type == Enums.type.CORE:
		var explosion
		managable_entity.get_node("Explosion").activate()
		core_hit_amount -= 1
		life -= int(MAX_LIFE/MAX_CORE_HIT_AMOUNT)
	else:
		life -= damage
	if life <= 0 or core_hit_amount <= 0:
		kill()

func kill():
	managable_entity.kill()
