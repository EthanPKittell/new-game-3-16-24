extends Area2D

var wave = 1
var enemyRunners = 0
var enemyBoxers = 0
var canSpawn = true
var spawnTimer = 5
var waveActive = false
var noLever = false #this checks if there is no lever currently in the world


@onready var SpawnArea1 = $SpawnArea1
@onready var SpawnArea2 = $SpawnArea2
@onready var SpawnArea3 = $SpawnArea3
@onready var waveTimer = $Timer


func _ready():
	randomize()


func _process(delta):
	if waveActive == true && canSpawn == true && (enemyRunners > 0 || enemyBoxers > 0):
		spawnEnemy()
		canSpawn = false
		
		
	if get_tree().get_nodes_in_group("Enemy").size() == 0 && noLever == true && waveActive == false:
		var world = get_tree().current_scene.get_node("Y_Sort")
		var lever = preload("res://Scenes/wave_lever.tscn")
		var leverInstance = lever.instantiate()
		world.add_child(leverInstance)
		leverInstance.global_position = Vector2(879, 246)
		noLever = false

func spawnEnemy():
	waveTimer.wait_time = spawnTimer
	waveTimer.start()
	

func _on_timer_timeout():
	var world = get_tree().current_scene.get_node("Y_Sort")
	#preload different enemies depending on the wave number
	
	#THIS IS THE RANDOM ENEMY GENERATOR UNCOMMENT WHEN DONE DEBUGGING
	var pick = randi_range(0,1)
	var enemy
	if enemyRunners <= 0 && pick == 0:
		pick = 1
	if enemyBoxers <= 0 && pick == 1:
		pick = 0
		
	if pick == 0:
		enemy = preload("res://Scenes/enemy_runner.tscn")
		enemyRunners -= 1
	elif pick == 1:
		enemy = preload("res://Scenes/enemy_boxer.tscn")
		enemyBoxers -= 1
	#enemy = preload("res://Scenes/enemy_boxer.tscn")
	
	
	var enemyInstance = enemy.instantiate()
	world.add_child(enemyInstance)
	var pickSpawn = randi_range(1,3)
	var spawnLocationOffset = Vector2(randf_range(-50,50), randf_range(-50,50))
	if pickSpawn == 1:
		enemyInstance.global_position = SpawnArea1.global_position + spawnLocationOffset
	elif pickSpawn == 2:
		enemyInstance.global_position = SpawnArea2.global_position + spawnLocationOffset
	elif pickSpawn == 3:
		enemyInstance.global_position = SpawnArea3.global_position + spawnLocationOffset
	
	canSpawn = true

	if enemyRunners <= 0 && enemyBoxers <= 0:
		waveActive = false
	waveTimer.stop()
	
func startWave():
	
	#sets the wave enemies depending on the current wave
	if wave == 1:
		enemyRunners = 5
		enemyBoxers = 0
	if wave == 2:
		spawnTimer = 2
		enemyRunners = 20
		enemyBoxers = 0
	if wave == 3:
		spawnTimer = 1
		enemyRunners = 0
		enemyBoxers = 10
	if wave == 4:
		spawnTimer = 0.2
		enemyRunners =40
		enemyBoxers = 20
	if wave == 5:
		spawnTimer = 0.1
		enemyRunners = 100
		enemyBoxers = 30
	print(wave)
	#increments the wave counter after pulling the wave level
	#and setting the enemies of the current wave
	wave = wave + 1
	noLever = true
