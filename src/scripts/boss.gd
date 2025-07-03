extends CharacterBody2D

signal weapon_detected
const velocidad = 100
const velocidadSalto = -500
const KNOCKBACK_SPEED = Vector2(40,-100)
const DAMAGE = 40
var dirMov := Enums.direction.RIGHT
var estaVivo:bool = true
var attacking:bool = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation := $AnimatedSprite2D
@onready var explosion := $Explosion

func _ready() -> void:
	animation.play("default")
	$HitManager.managable_entity = self


	
func _physics_process(delta):
	
	if estaVivo and not attacking and $"protection time".is_stopped() and $stunned.is_stopped():
		if not is_on_floor():
			velocity += get_gravity()*delta
		if $iFrames.is_stopped():
			if dirMov == Enums.direction.RIGHT:
				velocity.x = velocidad
			else:
				velocity.x = -1 * velocidad
		if is_on_floor():
			if $wall.is_colliding() and not $jump_check.is_colliding():
				animation.play("jump")
				velocity.y += velocidadSalto
			elif $wall.is_colliding() or $jump_check.is_colliding():
				change_direction()
		move_and_slide()
		if velocity.x != 0 and is_on_floor():
			animation.play("walk")
		if $range.is_colliding():
			attack()

func disable_hitbox(x_direction):
	$core/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	velocity = KNOCKBACK_SPEED
	animation.play("hit")
	velocity.x *= x_direction
	$iFrames.start()

func attack():
	attacking = true
	$attack_hitbox.start()
	animation.play("attack")
	$cooldown.start()

func change_direction():
	if dirMov == Enums.direction.LEFT:
		dirMov = Enums.direction.RIGHT
	else:
		dirMov = Enums.direction.LEFT
	scale.x *= -1

func kill():
	estaVivo = false
	animation.play("death")
	await  get_tree().create_timer(1).timeout
	var pos_save = animation.global_position
	var pos_explosion_save = explosion.global_position
	remove_child(animation)
	remove_child(explosion)
	get_tree().current_scene.add_child(explosion)
	get_tree().current_scene.add_child(animation)
	animation.global_position = pos_save
	explosion.global_position = pos_explosion_save
	animation.global_scale = Vector2(1.5,1.5)
	queue_free()


func _on_i_frames_timeout() -> void:
	$core/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false


func _on_cooldown_timeout() -> void:
	attacking = false
	$Ataque/CollisionShape2D.disabled = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if estaVivo:
		$AnimatedSprite2D.play("default")
	


func _on_ataque_body_entered(body: Node2D) -> void:
	if estaVivo and $"protection time".is_stopped() and $stunned.is_stopped():
		body.get_node("HitManager").what_to_do_if_you_get_hit(Enums.type.BODY,DAMAGE,global_position)


func _on_attack_hitbox_timeout() -> void:
	$Ataque/CollisionShape2D.disabled = false


func _on_radio_detection_body_entered(body: Node2D) -> void:
	var posistion_diference = body.global_position.x - global_position.x
	if (posistion_diference < 0 and dirMov == Enums.direction.RIGHT) or (posistion_diference > 0 and dirMov == Enums.direction.LEFT):
		change_direction()


func _on_shield_range_area_entered(area: Area2D) -> void:
	if area.name == "Xplosion" and $stunned.is_stopped():
		$shield/CollisionShape2D.disabled = false
		animation.play("block")
		$"protection time".start()	


func _on_protection_time_timeout() -> void:
	disable_shield()
	


func _on_shield_area_entered(area: Area2D) -> void:
	if area.name == "Xplosion":
		animation.play("blocked_hit")
		var xplosion = get_parent().get_node("Elementos/Mario/Xplosion")
		if xplosion.meleeing:
			$stunned.start()
			animation.play("default")
			disable_shield()

func disable_shield():
	$shield/CollisionShape2D.disabled = true
	$"protection time".stop()
