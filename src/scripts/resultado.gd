extends Control

@onready var boss: CharacterBody2D = $"../../Elementos/Enemigos/boss"
@onready var jugador: CharacterBody2D = $"../../Elementos/Mario"
@onready var MostradorTexto: Label = $Label
@onready var color_rect: ColorRect = $ColorRect
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const MENU_MUERTE = preload("res://src/Assets/Sounds/Sonidos/MenuMuerte.mp3")
const CROWD_CHEER = preload("res://src/Assets/Sounds/Sonidos/crowd-cheer-applause-victory-fanfare-clapping-236698.mp3")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	jugador.death.connect(on_muerte)
	boss.JefeDerrotado.connect(on_victoria)

	visible = false

func on_muerte() -> void:
	MostradorTexto.text = "Moriste"
	color_rect.color = Color(1, 0, 0.18, 0.41)
	audio_stream_player_2d.stream = MENU_MUERTE
	show_end_screen()

func on_victoria() -> void:
	MostradorTexto.text = "Victoria"
	color_rect.color = Color(0, 0.55, 0.15, 0.41)
	audio_stream_player_2d.stream = CROWD_CHEER
	show_end_screen()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func show_end_screen() -> void:
	visible = true
	audio_stream_player_2d.play()
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
