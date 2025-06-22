extends CharacterBody2D

const velocidad = 100
const velocidadSalto = -400
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
var dirMov : String = "derecha"
var estaVivo:bool = true
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var raycast2dDerecho: RayCast2D = $RayCast2DDerecho
@onready var raycast2dIzuierdo: RayCast2D = $RayCast2DIzuierdo

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	
func _physics_process(delta):
	if estaVivo:
		if not is_on_floor():
			velocity.y += gravedad*delta
		if dirMov == "derecha":
			velocity.x = velocidad
			if not raycast2dDerecho.is_colliding():
				dirMov="izquierda"
		else:
			velocity.x = -1 * velocidad
			if not raycast2dIzuierdo.is_colliding():
				dirMov="derecha"
		move_and_slide()
		
func _on_ataque_body_entered(body: Node2D) -> void:
	if dirMov == "derecha":
		dirMov = "izquierda"
	elif dirMov == "izquierda":
		dirMov = "derecha"
		
func _on_muerte_body_entered(body: Node2D) -> void:
	queue_free()

func muerte():
	$AnimatedSprite2D.play("Morte")
	await get_tree().create_timer(5).timeout
	estaVivo=false
	audio_stream_player_2d.play()
	queue_free()


func _on_muerte_area_entered(area: Area2D) -> void:
	queue_free()
