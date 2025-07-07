extends Node2D

@export var eject_speed := 100.0
@export var arc_height := -30.0
@export var landing_y_offset := 17.0  # how much lower the shell lands than it starts
@export var lifetime := 5.0
@export var facing_dir := 1  # 1 for right, -1 for left


var velocity := Vector2.ZERO
var start_y := 0.0
var t := 0.0
var duration := 0.6
var spin_velocity := 0.0

func _ready():
	randomize()

	start_y = global_position.y

	var x_spread = randf_range(80.0, 120.0)
	velocity = Vector2(facing_dir * x_spread, 0)

	spin_velocity = randf_range(-6.0, 6.0)

	set_process(true)


func _process(delta):
	t += delta

	# Move horizontally
	global_position.x += velocity.x * delta
	velocity.x = move_toward(velocity.x, 0, 100 * delta)

	# Spin and damp
	rotation += spin_velocity * delta
	spin_velocity = move_toward(spin_velocity, 0, 5 * delta)

	# Arc with adjusted landing Y
	var progress = clamp(t / duration, 0, 1)
	var height = arc_height * (1 - pow(2 * progress - 1, 2))
	global_position.y = start_y + height + (progress * landing_y_offset)

	if t >= lifetime:
		queue_free()
