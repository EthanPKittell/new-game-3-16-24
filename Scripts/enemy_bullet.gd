extends Area2D

var direction = Vector2.RIGHT
var speed = 570


func _ready():
	$Timer.wait_time = 0.05
	$Sprite2D.visible = false
	self.monitoring = false
	self.monitorable = false
	$Timer.start()

func _process(delta):
	translate(direction.normalized() * speed * delta)
	rotation = direction.angle()
	


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if !body.is_in_group("Enemy"):
		var explosion = preload("res://Scenes/Explosion.tscn")
		var explosionEffect = explosion.instantiate()
		var world = get_tree().current_scene
		world.add_child(explosionEffect)
		explosionEffect.global_position = global_position
		queue_free()


func _on_timer_timeout():
	$Sprite2D.visible = true
	self.monitoring = true
	self.monitorable = true




func _on_area_entered(area):
	if !area.is_in_group("EnemyArea"):
		var explosion = preload("res://Scenes/Explosion.tscn")
		var explosionEffect = explosion.instantiate()
		var world = get_tree().current_scene
		world.add_child(explosionEffect)
		explosionEffect.global_position = global_position
		queue_free()
