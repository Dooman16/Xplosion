extends CharacterBody2D

var speed: float = 100.0
# lo puse para probar si cambiaba de direccion
var maxDistancia: float = 200.0

#(-1: izquierda, 1: derecha)
var direction: int = 1

var posicionInicial: Vector2

func _ready():
	posicionInicial = global_position

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed

	move_and_slide()

	var distanciaRecorrida = global_position.x - posicionInicial.x
	if abs(distanciaRecorrida) >= maxDistancia:
		direction *= -1
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		scale.x *= -1

func kill():
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	kill()
