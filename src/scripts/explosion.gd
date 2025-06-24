extends AnimatedSprite2D

func activate():
	show()
	play("the only animation")
	$AudioStreamPlayer2D.play()

func _on_animation_finished() -> void:
	hide()
