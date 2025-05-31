extends Node2D

func _on_zona_nivel_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("JugadorGlobal"):
		GameData.EnAreaDeVictoria=true

func _on_zona_nivel_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("JugadorGlobal"):
		GameData.EnAreaDeVictoria=false
