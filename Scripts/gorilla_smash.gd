extends Area2D

var direction = Vector2.RIGHT
var speed = 200
@export var curve: Curve
var end_position
@export var offset := Vector2(-50, 0) # This sets how far in front of the gorilla it spawns
@onready var sceneName = get_parent().get_parent().name
@onready var player = Globals.playerRef#get_node("/root/World/Y_Sort/Player")
@onready var world = get_tree().current_scene#.get_node("Y_Sort")
var total_distance
var current_distance
var translation
var current_direction
var distance_normalized
var original_position

func _ready():
	
	$Timer.wait_time = 0.09
	$AnimatedSprite2D.visible = false
	$Timer.start()
	$AnimatedSprite2D.play("default")
	#if player != null:
	#	end_position = player.global_position
	#	original_position = self.global_position
		
		

func _process(delta):
	pass
	#translate(direction.normalized() * speed * delta)
	#rotation = direction.angle()
	#if player != null:
	#	current_distance = end_position - self.global_position
	#	current_direction = self.global_position.direction_to(end_position)
		#distance_normalized = 1 - $Timer_expire.get_time_left()/1.0
		#current_direction.y = current_direction.y - curve.sample(distance_normalized)
		
		
	#	translate(current_direction.normalized() * speed * delta)
		#rotation = current_direction.angle() #comment this out because I don't want the smash sprite to rotate
		#print(current_direction)
		
	#	if self.global_position.distance_to(end_position) < 5:
	#		queue_free()
	
	


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if !body.is_in_group("Enemy"):
		var explosion = preload("res://Scenes/Explosion.tscn")
		var explosionEffect = explosion.instantiate()
		world.add_child(explosionEffect)
		explosionEffect.global_position = global_position
		queue_free()


func _on_timer_timeout():
	$AnimatedSprite2D.visible = true





func _on_area_entered(area):
	if !area.is_in_group("EnemyArea"):
		var explosion = preload("res://Scenes/Explosion.tscn")
		var explosionEffect = explosion.instantiate()
		world.add_child(explosionEffect)
		explosionEffect.global_position = global_position
		queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
