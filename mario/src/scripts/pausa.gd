extends Control

var is_paused = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused
	
func resume():
	is_paused = false
	get_tree().paused = false
	visible = false
	
func _on_continuar_pressed() -> void:
	resume()
	
func _on_reiniciar_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	
func _on_salir_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")
		
