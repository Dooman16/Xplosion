extends CharacterBody2D

var speed: float = 100.0
# lo puse para probar si cambiaba de direccion
var maxDistancia: float = 200.0

#(-1: izquierda, 1: derecha)
var direction: int = 1

var posicionInicial: Vector2
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	posicionInicial = global_position
	$HitManager.managable_entity = self

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	progress_bar.value=$HitManager.life

	move_and_slide()

	var distanciaRecorrida = global_position.x - posicionInicial.x
	if abs(distanciaRecorrida) >= maxDistancia:
		direction *= -1
		$Sprite2D.flip_h = !$Sprite2D.flip_h
		scale.x *= -1

func kill():
	queue_free()
