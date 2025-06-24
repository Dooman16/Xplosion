extends CharacterBody2D

const velocidad = 100
const velocidadSalto = -200
const KNOCKBACK_SPEED = Vector2(50,-100)
const DAMAGE = 20
var dirMov := Enums.direction.RIGHT
var estaVivo:bool = true
var attacking:bool = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var raycast2dDerecho: RayCast2D = $RayCast2DDerecho
@onready var raycast2dIzuierdo: RayCast2D = $RayCast2DIzuierdo
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$HitManager.managable_entity = self
	
func _physics_process(delta):
	progress_bar.value=$HitManager.life
	if $range.is_colliding() and not attacking:
		attack()
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
				$AnimatedSprite2D.play("jump")
				velocity.y += velocidadSalto
			elif $wall.is_colliding():
				change_direction()
		move_and_slide()
		if velocity.x != 0 and is_on_floor():
			$AnimatedSprite2D.play("walk")

func muerte():
	$AnimatedSprite2D.play("Morte")
	await get_tree().create_timer(5).timeout
	estaVivo=false
	audio_stream_player_2d.play()
	queue_free()

func disable_hitbox(x_direction):
	$core/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	velocity = KNOCKBACK_SPEED
	if x_direction == 1 and dirMov == Enums.direction.LEFT:
		$AnimatedSprite2D.play("hit_front")
	else:
		$AnimatedSprite2D.play("hit_back")
	velocity.x *= x_direction
	$iFrames.start()

func attack():
	attacking = true
	$AnimatedSprite2D.position.y -= 3 
	$attack_hitbox.start()
	$AnimatedSprite2D.play("attack")
	$cooldown.start()
	

func change_direction():
	if dirMov == Enums.direction.LEFT:
		dirMov = Enums.direction.RIGHT
	else:
		dirMov = Enums.direction.LEFT
	scale.x *= -1

func kill():
	estaVivo = false
	$AnimatedSprite2D.play("death")
	await  get_tree().create_timer(1).timeout
	get_tree().current_scene.add_child($AnimatedSprite2D)
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
		$AnimatedSprite2D.position.y += 3 


func _on_ataque_body_entered(body: Node2D) -> void:
	body.get_node("HitManager").what_to_do_if_you_get_hit(Enums.type.BODY,DAMAGE,global_position)


func _on_attack_hitbox_timeout() -> void:
	$Ataque/CollisionShape2D.disabled = false
