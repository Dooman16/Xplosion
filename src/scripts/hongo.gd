extends CharacterBody2D

@export var hongoMostrar : Texture2D
@export var tipo : String
 
var velocidadHongo = 100
var dirMov : String = "derecha"
var gravedad=ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravedad*delta
	if dirMov == "derecha":
		velocity.x = 1 * velocidadHongo
		move_and_slide()
		return
	else:
		velocity.x = -1 * velocidadHongo
		move_and_slide()
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("hola :D")
	
