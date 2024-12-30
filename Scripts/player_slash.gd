extends Area2D

var direction = Vector2.RIGHT
var speed = 340

func _ready():
	$Timer.wait_time = 0.09
	$AnimatedSprite2D.visible = false
	$Timer.start()
	$AnimatedSprite2D.play("default")

func _process(delta):
	translate(direction.normalized() * speed * delta)
	rotation = direction.angle()
	if speed > 1:
		speed = speed - 20
	


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	var explosion = preload("res://Scenes/Explosion.tscn")
	var explosionEffect = explosion.instantiate()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position
	queue_free()


func _on_timer_timeout():
	$AnimatedSprite2D.visible = true





func _on_area_entered(area):
	var explosion = preload("res://Scenes/Explosion.tscn")
	var explosionEffect = explosion.instantiate()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
