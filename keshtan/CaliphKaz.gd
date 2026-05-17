extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SIDESTEP_SPEED = 3.0
const SIDESTEP_DURATION = 0.25

var sidestep_timer = 0.0
var sidestep_dir = 0.0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Left/Right only (Tekken style)
	var lr = 0.0
	if Input.is_action_pressed("ui_right"): lr += 1
	if Input.is_action_pressed("ui_left"): lr -= 1
	velocity.x = lr * SPEED

	# Sidestep (ui_up/ui_down = into/out of screen)
	if Input.is_action_just_pressed("ui_up") and sidestep_timer <= 0:
		sidestep_dir = -1.0
		sidestep_timer = SIDESTEP_DURATION
	if Input.is_action_just_pressed("ui_down") and sidestep_timer <= 0:
		sidestep_dir = 1.0
		sidestep_timer = SIDESTEP_DURATION

	if sidestep_timer > 0:
		velocity.z = sidestep_dir * SIDESTEP_SPEED
		sidestep_timer -= delta
	else:
		velocity.z = move_toward(velocity.z, 0, SIDESTEP_SPEED)

	move_and_slide()
