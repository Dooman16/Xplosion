extends Control

@onready var mario: CharacterBody2D = $"../../Elementos/Mario"
@onready var MostradorTexto: Label = $Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if mario != null:
		mario.death.connect(on_muerte)
	visible = false
	
func on_muerte():
	MostradorTexto.text = "Moriste"
	show_end_screen()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("q"):
		if GameData.EnAreaDeVictoria:
			MostradorTexto.text = "Victoria"
			show_end_screen()
			GameData.EnAreaDeVictoria=false
	else:
		pass
		
func show_end_screen():
	visible = true
	
func resume():
	visible = false
	
func _on_reiniciar_pressed() -> void:
	resume()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_salir_pressed() -> void:
	get_tree().paused = false
	resume()
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")

func mostrar(tequiste):
	if MostradorTexto:
		MostradorTexto.text = str(tequiste)
		print("Texto asignado al Label: ", tequiste)
	else:
		printerr("Error: Label no encontrado en la pantalla de resultados")
