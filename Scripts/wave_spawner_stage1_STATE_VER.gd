extends Area2D

enum State { IDLE, SPAWNING, WAITING, LEVER }

var state = State.IDLE
var wave = 1
var enemyRunners = 0
var enemyBoxers = 0
var enemyGorillas = 0
var spawnTimer = 5

const ENEMY_RUNNER = preload("res://Scenes/enemy_runner.tscn")
const ENEMY_BOXER = preload("res://Scenes/enemy_boxer.tscn")
const ENEMY_GORILLA = preload("res://Scenes/enemy_alien_gorilla.tscn")
const LEVER_SCENE = preload("res://Scenes/wave_lever.tscn")

@onready var SpawnArea1 = $SpawnArea1
@onready var SpawnArea2 = $SpawnArea2
@onready var SpawnArea3 = $SpawnArea3
@onready var waveTimer = $Timer

var wave_data = {
	1: {"enemyRunners": 5, "enemyBoxers": 1,"enemyGorillas": 1, "spawnTimer": 5},
	2: {"enemyRunners": 15, "enemyBoxers": 0,"enemyGorillas": 1, "spawnTimer": 4},
	3: {"enemyRunners": 0, "enemyBoxers": 10,"enemyGorillas": 0, "spawnTimer": 3},
	4: {"enemyRunners": 40, "enemyBoxers": 20,"enemyGorillas": 5, "spawnTimer": 2},
	5: {"enemyRunners": 50, "enemyBoxers": 30,"enemyGorillas": 15, "spawnTimer": 1},
}

func _ready():
	randomize()
	transition_to(State.LEVER)

func _process(delta):
	match state:
		State.SPAWNING:
			if enemyRunners > 0 or enemyBoxers > 0 or enemyGorillas:
				spawn_enemy()
				transition_to(State.WAITING)
			else:
				transition_to(State.LEVER)
		
		State.WAITING:
			#Waiting for timer to spawn next enemy
			pass
		
		State.LEVER:
			if get_tree().get_nodes_in_group("Enemy").is_empty():
				spawn_lever()
				transition_to(State.IDLE)
		
		State.IDLE:
			pass  #Waits for player to pull the lever (which calls start_wave())

func transition_to(new_state):
	state = new_state

func start_wave():
	if wave_data.has(wave):
		var waveInfo = wave_data[wave]
		enemyRunners = waveInfo.enemyRunners
		enemyBoxers = waveInfo.enemyBoxers
		enemyGorillas = waveInfo.enemyGorillas
		spawnTimer = waveInfo.spawnTimer
		wave += 1
		print("Wave started:", wave - 1)
		transition_to(State.SPAWNING)
	else:
		print("No more waves defined.")

func spawn_enemy():
	waveTimer.wait_time = spawnTimer
	waveTimer.start()

func _on_timer_timeout():
	var available_enemies = []

	if enemyRunners > 0:
		available_enemies.append(0)  #0 = Runner
	if enemyBoxers > 0:
		available_enemies.append(1)  #1 = Boxer
	if enemyGorillas > 0:
		available_enemies.append(2)  #2 = Gorilla

	if available_enemies.is_empty():
		#No enemies left to spawn
		waveTimer.stop()
		transition_to(State.LEVER)
		return

	# Pick randomly from what's left
	var pick = available_enemies[randi_range(0, available_enemies.size() - 1)]
	var enemy_scene

	match pick:
		0:
			enemy_scene = ENEMY_RUNNER
			enemyRunners -= 1
		1:
			enemy_scene = ENEMY_BOXER
			enemyBoxers -= 1
		2:
			enemy_scene = ENEMY_GORILLA
			enemyGorillas -= 1

	var instance = enemy_scene.instantiate()
	instance.global_position = get_random_spawn_location()
	get_tree().current_scene.get_node("Y_Sort").add_child(instance)

	# Schedule next spawn if there are still enemies
	if enemyRunners > 0 or enemyBoxers > 0 or enemyGorillas > 0:
		transition_to(State.SPAWNING)
	else:
		waveTimer.stop()
		transition_to(State.LEVER)

func spawn_lever():
	var leverInstance = LEVER_SCENE.instantiate()
	var world = get_tree().current_scene.get_node("Y_Sort")
	leverInstance.global_position = Vector2(879, 246)
	world.add_child(leverInstance)
	print("Lever spawned")

func get_random_spawn_location():
	var areas = [SpawnArea1, SpawnArea2, SpawnArea3]
	var chosen = areas[randi_range(0, areas.size() - 1)]
	return chosen.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
