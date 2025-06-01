extends Area2D

var wave = 1
var enemyRunners = 0
var enemyBoxers = 0
var canSpawn = true
var spawnTimer = 5
var waveActive = false
var noLever = false #this checks if there is no lever currently in the world

const ENEMY_RUNNER = preload("res://Scenes/enemy_runner.tscn")
const ENEMY_BOXER = preload("res://Scenes/enemy_boxer.tscn")


@onready var SpawnArea1 = $SpawnArea1
@onready var SpawnArea2 = $SpawnArea2
@onready var SpawnArea3 = $SpawnArea3
@onready var waveTimer = $Timer

#Modify this to change the contents of the wave
var wave_data = {
	1: {"enemyRunners": 5, "enemyBoxers": 0, "spawnTimer": 5},
	2: {"enemyRunners": 20, "enemyBoxers": 0, "spawnTimer": 2},
	3: {"enemyRunners": 0, "enemyBoxers": 10, "spawnTimer": 1},
	4: {"enemyRunners": 40, "enemyBoxers": 20, "spawnTimer": 0.2},
	5: {"enemyRunners": 100, "enemyBoxers": 30, "spawnTimer": 0.1},
	}


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
		enemy = ENEMY_RUNNER
		enemyRunners -= 1
	elif pick == 1:
		enemy = ENEMY_BOXER
		enemyBoxers -= 1
	#enemy = preload("res://Scenes/enemy_boxer.tscn")
	
	
	var enemyInstance = enemy.instantiate()
	var spawnLocation = get_random_spawn_location()
	enemyInstance.global_position = spawnLocation
	get_tree().current_scene.get_node("Y_Sort").add_child(enemyInstance)
	
	canSpawn = true

	if enemyRunners <= 0 && enemyBoxers <= 0:
		waveActive = false
	waveTimer.stop()
	
func get_random_spawn_location():
	var areas = [SpawnArea1, SpawnArea2, SpawnArea3]
	var chosen = areas[randi_range(0, areas.size() - 1)]
	return chosen.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))	

func startWave():
	
	#sets the wave enemies depending on the current wave
	if wave_data.has(wave): 
		var waveInfo = wave_data[wave]
		enemyRunners = waveInfo.enemyRunners
		enemyBoxers = waveInfo.enemyBoxers
		spawnTimer = waveInfo.spawnTimer
		#increments the wave counter after pulling the wave level
		#and setting the enemies of the current wave
		wave += 1
		noLever = true
		print("Wave started:", wave - 1)
	else:
		print("No more waves defined.")
	
	
