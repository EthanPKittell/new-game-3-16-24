extends CharacterBody2D

#@onready var player = get_node("/root/World/Y_Sort/Player")
#@onready var player_global_pos = player.global_position
#var target_position
@onready var anim = $Blink
var health = 10
var speed = 100
var accuracyValue = 0.2
var canFire = true #I set it to false because when You start you have no gun
var fireRate = 0.2
var inRange = false
var attackAble = false
var shootingOffset = Vector2(0,-20) #offset for where the bullets are starting
#@export var player: Node2D
@onready var sceneName = get_parent().get_parent().name
@onready var player = get_node("/root/"+ sceneName +"/Y_Sort/Player")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var shotTimer = $ShotTimer
@onready var softCollision = $SoftCollision
@onready var playerSight = $RayCast2D
@onready var seekerSprite = $Sprite2D



enum {
	IDLE, #unused state
	WANDER, #unused state
	CHASE,
	ATTACK
}

var state = CHASE


func _physics_process(_delta: float) -> void:
	#detecting if the player is actually able to be shot at
	if player != null:
		var direction_to_player = (player.global_position - self.global_position)
		#print(direction_to_player)
		playerSight.target_position = direction_to_player
		playerSight.force_raycast_update()
		var collision_object = playerSight.get_collider()
		if collision_object == player:
			inRange = true
		else:
			inRange = false
			
		
		#This fixes the issue where staying in attack range does trigger attack when behind walls
		if attackAble == true && inRange == true: 
			state = ATTACK
	#if chase == true:
	#add wander and idle later (wander most likely moves around the area 
	#and idle changes animation)
	match state:
		CHASE:
			var next_path_pos := nav_agent.get_next_path_position()
			var dir := global_position.direction_to(next_path_pos)
			velocity = dir * speed
			if softCollision.is_colliding():
				velocity += softCollision.get_push_vector() * 20
			move_and_slide()
			
			if player.global_position.x > self.global_position.x:
				seekerSprite.flip_h = false
			elif player.global_position.x < self.global_position.x:
				seekerSprite.flip_h = true
		ATTACK:
			if canFire == true:
				shoot()
				canFire = false
				shotTimer.wait_time = fireRate
				shotTimer.start()
			if softCollision.is_colliding():
				velocity = Vector2(0,0)
				velocity += softCollision.get_push_vector() * 20
				move_and_slide()
				
			if player.global_position.x > self.global_position.x:
				seekerSprite.flip_h = false
			elif player.global_position.x < self.global_position.x:
				seekerSprite.flip_h = true
	#print(chase)
	
	if health < 1:
		var world = get_tree().current_scene
		var health = preload("res://Scenes/healthPickup.tscn")
		var healthPickup = health.instantiate()
		world.add_child(healthPickup)
		healthPickup.global_position = global_position
		queue_free()
		
func _on_hurtbox_area_entered(area):
	if area.is_in_group("PlayerProjectile"):
		health = health - Globals.playerDamage
		anim.play("blink")
		if state != CHASE:
			state = CHASE


func _on_timer_timeout():
	if player != null:
		makepath()

func makepath() -> void:
	nav_agent.target_position = player.global_position
	
	

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		if state != CHASE and state != ATTACK:
			state = CHASE


func _on_attack_range_body_entered(body):
	if body.is_in_group("Player"):
		attackAble = true
		if state != ATTACK && inRange == true:
			state = ATTACK


func _on_attack_range_body_exited(body):
	if body.is_in_group("Player"):
		state = CHASE
		attackAble = false
		
func shoot():
	#create bullet
	var world = get_tree().current_scene
	var accuracy = Vector2(randf_range(-accuracyValue,accuracyValue), randf_range(-accuracyValue,accuracyValue))
	var bullet = preload("res://Scenes/enemy_bullet.tscn")
	var shot = bullet.instantiate()
	
	world.add_child(shot)
	shot.global_position = global_position + shootingOffset
	shot.direction = (player.global_position - self.global_position).normalized() + accuracy
	


func _on_shot_timer_timeout():
	canFire = true
	$ShotTimer.stop()
