extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

var current_form: Transformable = null   # объект в котором сидим
var nearby_form: Transformable = null
@onready var camera: Camera2D = $Camera2D
@onready var ui_player: Control = $"UI Player"
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animated: AnimatedSprite2D = $Animated
@onready var land_particles: GPUParticles2D = $LandParticles

var max_energy = 100
var zum_camera_x_y = 3.6
var offset_y = 0
var walk_timer := 0.0
const WALK_INTERVAL = 0.35
@onready var walk_sound: AudioStreamPlayer = $WalkAudio
var menu_reset = false

var die_check = false

enum  State {IDLE, RUN, FALL, LAND, JUMP, DIE}
var states = State.IDLE
func change_state(state):
	states = state
	animated.speed_scale = 1.0
	match  state:
		State.IDLE:
			animated.play_backwards("idle")
		State.RUN:
			animated.speed_scale = 2.0
			animated.play_backwards("run")
		State.LAND:
			animated.play("land")
		State.FALL:
			animated.play("fall")
		State.JUMP:
			animated.play("jump")
		State.DIE:
			animated.play("die")
			$DieAudio.play()

func _ready() -> void:
	
	Global.leave_key = 0
	Global.check_door = 0
	add_to_group("camera_target")
	if OS.has_feature("mobile"):
		point_light_2d.shadow_enabled = false

func _physics_process(delta: float) -> void:
	var was_on_floor = is_on_floor()
	if die_check:
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	if get_tree().current_scene.name == "MainMenu":
		zoom_camera(1, 1, 0)
		direction = 0
	
	velocity.x = direction * SPEED
	if direction < 0:
		animated.flip_h = true
	if direction > 0:
		animated.flip_h = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	if current_form != null:
		# Управление объектом
		current_form.velocity = current_form.get_vector()
		var pre_slide_velocity = current_form.velocity
		current_form.move_and_slide()
		current_form.apply_bounce(pre_slide_velocity)
	else:
		if is_on_floor() and abs(velocity.x) > 10:
			walk_timer += delta
			if walk_timer >= WALK_INTERVAL:
				walk_timer = 0.0
				walk_sound.play(1.8)
		else:
			walk_timer = 0.0
			walk_sound.stop()
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			change_state(State.JUMP)
		match  states:
			State.IDLE:
				if direction:
					change_state(State.RUN)
				if not is_on_floor():
					change_state(State.FALL)
			State.RUN:
				if not direction:
					velocity.x = move_toward(velocity.x, 0, SPEED)
					change_state(State.IDLE)
				
			State.JUMP:
				if not is_on_floor() and velocity.y < 0:
					change_state(State.FALL)
				else:
					velocity.y = JUMP_VELOCITY
			State.FALL:
				if is_on_floor():
					change_state(State.LAND)
			State.DIE:
				die_check = true
			State.LAND:
				land_particles.emitting = true
		move_and_slide()
		if is_on_wall() and not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 10)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("transform"):
		if current_form:
			_exit_form()
		elif nearby_form and not nearby_form.is_occupied:
			_enter_form(nearby_form)
	if event.is_action_pressed("esc"):
		if not menu_reset:
			menu_reset = true
			ResetMenu.show_menu()
		else:
			menu_reset = false
			ResetMenu.hide_menu()

func _enter_form(form: Transformable) -> void:
	var tween = create_tween()
	tween.tween_property(point_light_2d, "energy", 5.0, 0.1)
	tween.tween_property(point_light_2d, "energy", 1.0, 0.3)
	var energy = ui_player.energy_bar.value
	if energy <= 1:
		return
	ui_player.update_energy(energy-(max_energy/4), max_energy)
	current_form = form
	form.on_enter()
	
	# Игрок исчезает
	visible = false
	# Отключаем физику игрока чтобы он не падал невидимый
	$CollisionShape2D.disabled = true
	
	# Камера переезжает к объекту
	camera.reparent(form)
	zoom_camera(zum_camera_x_y, zum_camera_x_y, offset_y)
	point_light_2d.reparent(form)
	point_light_2d.position = Vector2.ZERO
	camera.position = Vector2.ZERO  # центрируем на объекте

func _exit_form() -> void:
	# Игрок появляется рядом с объектом
	position = current_form.position + Vector2(0, -60)
	# Камера возвращается к игроку
	camera.reparent(self)
	zoom_camera(zum_camera_x_y, zum_camera_x_y, offset_y)
	point_light_2d.reparent(self)
	point_light_2d.position = Vector2.ZERO
	camera.position = Vector2.ZERO
	
	current_form.on_exit()
	current_form = null
	
	visible = true
	$CollisionShape2D.disabled = false
	
func set_nearby_form(form) -> void:
	nearby_form = form

func _on_area_2d_body_entered(body: Node2D) -> void:
	var energy = ui_player.energy_bar.value
	if body.has_method("hill"):
		$Hill.play()
		if energy < max_energy:
			ui_player.update_energy(energy+body.hill(), max_energy)

func die():
	change_state(State.DIE)


func _on_animated_animation_finished() -> void:
	match  states:
		State.LAND:
			if Input.get_axis("a", "d") != 0:
				change_state(State.RUN)
			else:
				change_state(State.IDLE)
		State.FALL:
			if is_on_floor():
				change_state(State.LAND)
		State.DIE:
			ResetMenu.show_menu()

func zoom_camera(x, y, offset):
	camera.zoom = Vector2(x, y)
	camera.offset.y = offset
	offset_y = offset
	zum_camera_x_y = x
