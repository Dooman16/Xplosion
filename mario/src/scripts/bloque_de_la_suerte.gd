extends Area2D

var item = preload("res://src/components/hongo1.tscn")
var usado: bool = false

func _ready():
	$AnimatedSprite2D.play("default")
	
func _on_body_entered(body: Node2D) -> void:
	if not usado and body.is_in_group("JugadorGlobal"):
		var hongo = item.instantiate()
		hongo.global_position = $Marker2D.global_position
		hongo.tipo = "crecer"
		get_parent().add_child(hongo)
		$AnimatedSprite2D.play("usado")
		usado = true
	
