extends Node2D


var entered = false
@onready var leverAnimation = $AnimatedSprite2D
@onready var waveSpawner =  get_node_or_null("/root/World/WaveSpawnerStage1")
var itemRef
var itemRef1
var itemRef2
var itemRef3
var shopKeeperRef
@onready var shopTimer = $AddShop

func _on_area_2d_body_entered(body):
	entered = true


func _on_area_2d_body_exited(body):
	entered = false
	
func _physics_process(delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			leverAnimation.play("default")
		


func _on_animated_sprite_2d_animation_finished():
	#waveSpawner.waveActive = true
	#Avoids pulling the lever multiple times and only triggers the wave when the spawner is ready
	if waveSpawner and waveSpawner.state == waveSpawner.State.IDLE:
		waveSpawner.start_wave()
	
	#create smoke for disapearing assets
	
	var world = get_tree().current_scene
	var smoke = preload("res://Scenes/smoke_evaporate.tscn")
	var smoke_evaporate = smoke.instantiate()
	var smoke_evaporate1 = smoke.instantiate()
	var smoke_evaporate2 = smoke.instantiate()
	var smoke_evaporate3 = smoke.instantiate()
	var smoke_evaporate4 = smoke.instantiate()
	
	world.add_child.call_deferred(smoke_evaporate)
	world.add_child.call_deferred(smoke_evaporate1)
	world.add_child.call_deferred(smoke_evaporate2)
	world.add_child.call_deferred(smoke_evaporate3)
	world.add_child.call_deferred(smoke_evaporate4)
	
	smoke_evaporate.global_position = shopKeeperRef.global_position
	smoke_evaporate1.global_position = itemRef.global_position
	smoke_evaporate2.global_position = itemRef1.global_position
	smoke_evaporate3.global_position = itemRef2.global_position
	smoke_evaporate4.global_position = itemRef3.global_position
	
	
	
	shopKeeperRef.queue_free()
	itemRef.queue_free()
	itemRef1.queue_free()
	itemRef2.queue_free()
	itemRef3.queue_free()
	queue_free()

func _ready():
	shopTimer.wait_time = 0.1
	shopTimer.start()
	



func _on_add_shop_timeout():
	shopTimer.stop()
	var world = get_tree().current_scene
	
	var item = preload("res://Scenes/item_upgrade.tscn")
	var item_upgrade = item.instantiate()
	itemRef = item_upgrade
	world.add_child.call_deferred(item_upgrade)
	item_upgrade.global_position = global_position + Vector2(-150, -100)
	item_upgrade.state = 0
	
	var item1 = preload("res://Scenes/item_upgrade.tscn")
	var item_upgrade1 = item1.instantiate()
	itemRef1 = item_upgrade1
	world.add_child.call_deferred(item_upgrade1)
	item_upgrade1.global_position = global_position + Vector2(-50, -100)
	item_upgrade1.state = 1
	
	var item2 = preload("res://Scenes/item_upgrade.tscn")
	var item_upgrade2 = item2.instantiate()
	itemRef2 = item_upgrade2
	world.add_child.call_deferred(item_upgrade2)
	item_upgrade2.global_position = global_position + Vector2(50, -100)
	item_upgrade2.state = 2
	
	var item3 = preload("res://Scenes/item_upgrade.tscn")
	var item_upgrade3 = item3.instantiate()
	itemRef3 = item_upgrade3
	world.add_child.call_deferred(item_upgrade3)
	item_upgrade3.global_position = global_position + Vector2(150, -100)
	item_upgrade3.state = 3
	
	world = get_tree().current_scene.get_node("Y_Sort")
	var shopKeeper = preload("res://Scenes/shop_keeper.tscn")
	var shopKeeperInstance = shopKeeper.instantiate()
	shopKeeperRef = shopKeeperInstance
	world.add_child.call_deferred(shopKeeperInstance)
	shopKeeperInstance.global_position = global_position + Vector2(0, -200)
	
	#smoke effect for spawning in shop
	
	world = get_tree().current_scene
	var smoke = preload("res://Scenes/smoke_evaporate.tscn")
	var smoke_evaporate = smoke.instantiate()
	var smoke_evaporate1 = smoke.instantiate()
	var smoke_evaporate2 = smoke.instantiate()
	var smoke_evaporate3 = smoke.instantiate()
	var smoke_evaporate4 = smoke.instantiate()
	
	world.add_child.call_deferred(smoke_evaporate)
	world.add_child.call_deferred(smoke_evaporate1)
	world.add_child.call_deferred(smoke_evaporate2)
	world.add_child.call_deferred(smoke_evaporate3)
	world.add_child.call_deferred(smoke_evaporate4)
	
	smoke_evaporate.global_position = shopKeeperRef.global_position
	smoke_evaporate1.global_position = itemRef.global_position
	smoke_evaporate2.global_position = itemRef1.global_position
	smoke_evaporate3.global_position = itemRef2.global_position
	smoke_evaporate4.global_position = itemRef3.global_position
