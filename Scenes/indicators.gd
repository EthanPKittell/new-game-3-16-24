# Attach this to the RadarUI (CanvasLayer)
extends CanvasLayer

@export var marker_scene: PackedScene
var markers = {}

func _process(_delta):
	for enemy in markers.keys():
		if !is_instance_valid(enemy):
			remove_enemy(enemy)
			continue

		var marker = markers[enemy]
		update_marker(enemy, marker)

func add_enemy(enemy: Node2D):
	if enemy in markers:
		return

	var marker = marker_scene.instantiate()
	add_child(marker)  # Add to this CanvasLayer
	markers[enemy] = marker

func remove_enemy(enemy: Node2D):
	if enemy in markers:
		markers[enemy].queue_free()
		markers.erase(enemy)

func update_marker(enemy: Node2D, marker: Node2D):
	var viewport := get_viewport()
	var camera := viewport.get_camera_2d()
	if camera == null:
		return

	var screen_size := viewport.get_visible_rect().size
	var screen_center := screen_size * 0.5

	# Convert enemy world position to screen position relative to the camera
	var screen_pos := (enemy.global_position - camera.global_position) * camera.zoom + screen_center

	# Check if enemy is on screen
	if screen_pos.x >= 0 and screen_pos.x <= screen_size.x and screen_pos.y >= 0 and screen_pos.y <= screen_size.y:
		marker.visible = false
	else:
		marker.visible = true
		# Clamp marker to screen bounds
		screen_pos = screen_pos.clamp(Vector2(10, 10), screen_size - Vector2(10, 10))
		marker.global_position = screen_pos
