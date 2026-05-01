extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -310.0

var current_form: Transformable = null   # объект в котором сидим
var nearby_form: Transformable = null
@onready var camera: Camera2D = $Camera2D
@onready var ui_player: Control = $"UI Player"
@onready var point_light_2d: PointLight2D = $PointLight2D

var max_energy = 100

func _ready() -> void:
	add_to_group("camera_target")

func _physics_process(delta: float) -> void:
	if current_form != null:
		# Управление объектом
		current_form.velocity = current_form.get_vector()
		var pre_slide_velocity = current_form.velocity
		current_form.move_and_slide()
		current_form.apply_bounce(pre_slide_velocity)
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("ui_left", "ui_right")

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("transform"):
		if current_form:
			_exit_form()
		elif nearby_form and not nearby_form.is_occupied:
			_enter_form(nearby_form)

func _enter_form(form: Transformable) -> void:
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
	point_light_2d.reparent(form)
	point_light_2d.position = Vector2.ZERO
	camera.position = Vector2.ZERO  # центрируем на объекте

func _exit_form() -> void:
	# Игрок появляется рядом с объектом
	position = current_form.position + Vector2(0, -60)
	
	# Камера возвращается к игроку
	camera.reparent(self)
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
		if energy < max_energy:
			ui_player.update_energy(energy+body.hill(), max_energy)

func die():
	get_tree().reload_current_scene()
