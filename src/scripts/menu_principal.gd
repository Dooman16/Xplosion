extends Control

@onready var sonido_boton := preload("res://src/Sounds/Sonidos/Boton.mp3")

func _on_salir_pressed() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = sonido_boton
	add_child(sound)
	sound.play()
	await sound.finished
	get_tree().quit() 
	
func _on_ajustes_pressed() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = sonido_boton
	add_child(sound)
	sound.play()
	await sound.finished
	get_tree().change_scene_to_file("res://src/sences/configuracion.tscn")
	
func _on_juagr_pressed() -> void:
	var sound := AudioStreamPlayer.new()
	sound.stream = sonido_boton
	add_child(sound)
	sound.play()
	await sound.finished
	get_tree().change_scene_to_file("res://src/sences/world2.tscn")	
