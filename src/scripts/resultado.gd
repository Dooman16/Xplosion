extends Control

@onready var mario: CharacterBody2D = $"../../Elementos/Mario"
@onready var jefe := $"../../Elementos/Jefe"  # Ajustá esta ruta según tu árbol de nodos
@onready var MostradorTexto: Label = $Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if mario:
		mario.death.connect(on_muerte)

	if jefe:
		jefe.defeated.connect(on_victoria)

	visible = false

func on_muerte() -> void:
	MostradorTexto.text = "Moriste"
	show_end_screen()

func on_victoria() -> void:
	MostradorTexto.text = "Victoria"
	show_end_screen()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func show_end_screen() -> void:
	visible = true
	get_tree().paused = true

func resume() -> void:
	visible = false
	get_tree().paused = false

func _on_reiniciar_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_salir_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")

func mostrar(tequiste) -> void:
	if MostradorTexto:
		MostradorTexto.text = str(tequiste)
		print("Texto asignado al Label: ", tequiste)
	else:
		printerr("Error: Label no encontrado en la pantalla de resultados")
