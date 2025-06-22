extends Control

func _on_juagr_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/world.tscn")
	
func _on_salir_pressed() -> void:
	get_tree().quit() 
	
func _on_ajustes_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/configuracion.tscn")
	
