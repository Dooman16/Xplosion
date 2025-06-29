extends CharacterBody2D

const velocidad = 100
const velocidadSalto = -500
const KNOCKBACK_SPEED = Vector2(40,-100)
const DAMAGE = 40
var dirMov := Enums.direction.RIGHT
var estaVivo:bool = true
var attacking:bool = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var raycast2dDerecho: RayCast2D = $RayCast2DDerecho
@onready var raycast2dIzuierdo: RayCast2D = $RayCast2DIzuierdo
@onready var animation := $AnimatedSprite2D
@onready var explosion := $Explosion
@onready var SuperEnemy: AudioStreamPlayer2D = $AudioStreamPlayer2D2
const MUERTE_ENEMIGO = preload("res://src/Sounds/Sonidos/MuerteEnemigo.mp3")
signal JefeDerrotado

func _ready() -> void:
	animation.play("default")
	$HitManager.managable_entity = self
	SuperEnemy.play()
	
func _physics_process(delta):
	
	if estaVivo and not attacking:
		if not is_on_floor():
			velocity += get_gravity()*delta
		if $iFrames.is_stopped():
			if dirMov == Enums.direction.RIGHT:
				velocity.x = velocidad
				if not raycast2dDerecho.is_colliding() and is_on_floor():
					change_direction()
			else:
				velocity.x = -1 * velocidad
				if not raycast2dIzuierdo.is_colliding() and is_on_floor():
					change_direction()
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
	
	var sound := AudioStreamPlayer.new()
	sound.stream = MUERTE_ENEMIGO
	add_child(sound)
	sound.play()
	await sound.finished
	
	emit_signal("JefeDerrotado")
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
	if estaVivo:
		body.get_node("HitManager").what_to_do_if_you_get_hit(Enums.type.BODY,DAMAGE,global_position)


func _on_attack_hitbox_timeout() -> void:
	$Ataque/CollisionShape2D.disabled = false


func _on_radio_detection_body_entered(body: Node2D) -> void:
	var posistion_diference = body.global_position.x - global_position.x
	if (posistion_diference < 0 and dirMov == Enums.direction.RIGHT) or (posistion_diference > 0 and dirMov == Enums.direction.LEFT):
		change_direction()
