extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -375
const KNOCKBACK_SPEED = Vector2(100,-200)

@onready var coyote_time: Timer = $CoyoteTime
@onready var input_buffer: Timer = $InputBuffer
@onready var animations: AnimatedSprite2D = $Animations
@onready var progress_bar: ProgressBar = $ProgressBar

signal on_player_jump
signal death

var was_on_floor = false
var has_recently_fallen_off_edge = false
var jump_buffered = false
var is_jumping_held = false

# Vaya....
var is_y_velocity_reset = false
var jumped_this_frame = false
var jumped_last_frame = false

func _ready() -> void:
	$HitManager.managable_entity = self
	$HitManager.Hitted.connect(actualizarBarra)
	actualizarBarra()
	#se conecta la señal y se actualiza la barra por primera vez, para que tenga barra de la vida completa del principio
	
#hay un bug que te deja hacer doble salto si ambos timers no terminan lol!!!!!
func _physics_process(delta: float) -> void:
	print(position.y)

	jumped_last_frame = jumped_this_frame
	jumped_this_frame = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_y_velocity_reset = false
	
	if Input.is_action_just_pressed("player_jump"):
		is_jumping_held = true
		jump_buffered = true
		input_buffer.start()
	
	# Handle jump.
	if jump_buffered and (is_on_floor() or has_recently_fallen_off_edge):
		jump()
		if not is_jumping_held:
			slow_upward_movement()
	
	
	if was_on_floor and (not is_on_floor()):
		#Deja de tocar el piso
		if not jumped_last_frame:
			has_recently_fallen_off_edge = true
			coyote_time.start()
	
	if Input.is_action_just_released("player_jump"):
		is_jumping_held = false

	if velocity.y < 0 and (not is_y_velocity_reset) and (not is_jumping_held):
		slow_upward_movement()
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("player_move_left", "player_move_right")
	if $iFrames.is_stopped():
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0:
		animations.flip_h = true
	elif direction < 0:
		animations.flip_h = false
	
	if not is_on_floor():
		animations.play("jump")
	elif direction == 0:
		animations.play("idle")
	else:
		animations.play("walk")
	
	was_on_floor = is_on_floor()
	move_and_slide()

func actualizarBarra():
	progress_bar.value=$HitManager.life

func slow_upward_movement():
	is_y_velocity_reset = true
	velocity.y = velocity.y/1.5

func jump():
	jumped_this_frame = true
	has_recently_fallen_off_edge = false
	force_finish_timer(coyote_time)
	force_finish_timer(input_buffer)
	on_player_jump.emit()
	velocity.y = JUMP_VELOCITY

func _on_coyote_time_timeout() -> void:
	has_recently_fallen_off_edge = false


func _on_input_buffer_timeout() -> void:
	jump_buffered = false

func force_finish_timer(timer:Timer):
	timer.stop()
	timer.emit_signal("timeout")

func disable_hitbox(x_direction):
	$CollisionShape2D.disabled = true
	velocity = KNOCKBACK_SPEED
	velocity.x *= x_direction
	$iFrames.start()

func reset_position(destination):
	global_position = destination
	force_finish_timer(coyote_time)
	force_finish_timer(input_buffer)


func _on_i_frames_timeout() -> void:
	$CollisionShape2D.disabled = false

func kill():
	get_tree().change_scene_to_file("res://src/sences/MenuPrinc.tscn")
