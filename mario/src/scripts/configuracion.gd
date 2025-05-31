extends Control


func _on_sonido_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)

func _on_mutear_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")

func _on_brillo_changed(value) -> void:
	var brightness = clamp(value / 100, 0.1, 1.0)	
	var env = get_viewport().get_camera_3d().environment if get_viewport().get_camera_3d() else null
	if env:
		env.adjustment_brightness = brightness
	else:
		var canvas_mod = get_viewport().canvas_item_light_modulate
		canvas_mod.a = brightness
		get_viewport().canvas_item_light_modulate = canvas_mod
		
func _get_current_brightness() -> float:
	var env = get_viewport().get_camera_3d().environment if get_viewport().get_camera_3d() else null
	if env:
		return env.adjustment_brightness
	else:
		return get_viewport().canvas_item_light_modulate.a
