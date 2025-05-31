extends Control

#var popup = PopupPanel.new()
#var label = Label.new()
	
func _on_nivel_prueba_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/mundoPrueba.tscn")
	
func _on_nivel_1_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/NivelUno.tscn")
	#if GameData.nivelPrueba:
		#get_tree().change_scene_to_file("res://src/sences/NivelUno.tscn")
	#else:
		#label.text = "¡Complete el nivel de prueba!"
		#popup.add_child(label)
		#add_child(popup)
		#popup.popup_centered(Vector2(200, 100))
		#var timer = Timer.new()
		#popup.add_child(timer)
		#timer.wait_time = 5.0  # 5 segundos
		#timer.one_shot = true
		#timer.timeout.connect(popup.queue_free)
		#timer.start()
		
	
func _on_nivel_2_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/NivelDos.tscn")
	#if GameData.nivelUnoCompletado:
		#get_tree().change_scene_to_file("res://src/sences/NivelDos.tscn")
	#else:
		#label.text = "¡Complete el nivel1!"
		#popup.add_child(label)
		#add_child(popup)
		#popup.popup_centered(Vector2(200, 100))
		#var timer = Timer.new()
		#popup.add_child(timer)
		#timer.wait_time = 5.0  # 5 segundos
		#timer.one_shot = true
		#timer.timeout.connect(popup.queue_free)
		#timer.start()
	
func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")
	
