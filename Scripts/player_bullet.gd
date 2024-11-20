extends Area2D

var direction = Vector2.RIGHT
var speed = 700

func _ready():
	$Timer.wait_time = 0.09
	$Sprite2D.visible = false
	$Timer.start()

func _process(delta):
	translate(direction.normalized() * speed * delta)
	rotation = direction.angle()
	


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
	$Sprite2D.visible = true





func _on_area_entered(area):
	var explosion = preload("res://Scenes/Explosion.tscn")
	var explosionEffect = explosion.instantiate()
	var world = get_tree().current_scene
	world.add_child(explosionEffect)
	explosionEffect.global_position = global_position
	queue_free()
