extends CharacterBody2D

const velocidad = 300
var velocidadSalto = -300

var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
var estado = "default"
var tamanio = "normal"

var en_zona_victoria = false
var pantalla_resultado = preload("res://src/sences/resutuque.tscn")

@onready var salto: AudioStreamPlayer2D = $"../../Sonidos/salto"
@onready var power_up: AudioStreamPlayer2D = $"../../Sonidos/powerUp"
@onready var perder_poder: AudioStreamPlayer2D = $"../../Sonidos/PerderPoder"
@onready var muerte_total: AudioStreamPlayer2D = $"../../Sonidos/MuerteTotal"

signal murio

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravedad * delta
		if tamanio == "normal":
			actualizarEstado("salto")
		else:
			actualizarEstado("grandeSalto")
			
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("w")) and is_on_floor():
		velocity.y = velocidadSalto
		salto.play()
	
	var direccion = Input.get_axis("a", "d")
	
	if direccion > 0:
		$AnimatedSprite2D.flip_h = false
	elif direccion < 0:
		$AnimatedSprite2D.flip_h = true
		
	if direccion:
		velocity.x = direccion * velocidad
		if tamanio == "normal":
			actualizarEstado("caminar")
		else:
			actualizarEstado("grandeCaminar")
	else:
		if tamanio == "normal":
			actualizarEstado("default")
		else:
			actualizarEstado("grandeDefault")
		velocity.x = move_toward(velocity.x, 0, velocidad)
	move_and_slide()
	
	if Input.is_action_pressed("q"):
		if GameData.EnAreaDeVictoria==true:
			mostrar_resultado("GANASTE")
			get_tree().paused=true

func comerHongo(tipo: String):
	if tipo == "crecer":
		tamanio = "grande"
		power_up.play()
		velocidadSalto = -350
		$CollisionShape2D.scale.y = 1.8
		actualizarEstado(estado)

func cambiarEstados():
	match estado:
		"default":
			$AnimatedSprite2D.play("default")
		"caminar":
			$AnimatedSprite2D.play("caminar")
		"salto":
			$AnimatedSprite2D.play("salto")
		"dead":
			$AnimatedSprite2D.play("dead")
		"grandeDefault":
			$AnimatedSprite2D.play("grandeDefault")
		"grandeCaminar":
			$AnimatedSprite2D.play("grandeCaminar")
		"grandeSalto":
			$AnimatedSprite2D.play("grandeSalto")
			
func actualizarEstado(nuevoEstado: String):
	estado = nuevoEstado
	cambiarEstados()

func JuegoTerminado():
	if tamanio == "normal":
		emit_signal("murio")
		muerte_total.play()		
		mostrar_resultado("MORISTE")
		get_tree().paused=true
	else:
		$CollisionShape2D.scale.y = 1
		tamanio = "normal"
		perder_poder.play()
	
func mostrar_resultado(mensaje: String):
	if pantalla_resultado:
		var resultado = pantalla_resultado.instantiate()
		get_tree().root.add_child(resultado) 
		resultado.mostrar(mensaje)
		print("Mensaje mostrado: ", mensaje)
	else:
		printerr("Error: No se pudo cargar pantalla_resultado")
