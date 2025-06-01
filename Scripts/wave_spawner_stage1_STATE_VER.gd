extends Area2D

enum State { IDLE, SPAWNING, WAITING, LEVER }

var state = State.IDLE
var wave = 1
var enemyRunners = 0
var enemyBoxers = 0
var spawnTimer = 5

const ENEMY_RUNNER = preload("res://Scenes/enemy_runner.tscn")
const ENEMY_BOXER = preload("res://Scenes/enemy_boxer.tscn")
const LEVER_SCENE = preload("res://Scenes/wave_lever.tscn")

@onready var SpawnArea1 = $SpawnArea1
@onready var SpawnArea2 = $SpawnArea2
@onready var SpawnArea3 = $SpawnArea3
@onready var waveTimer = $Timer

var wave_data = {
	1: {"enemyRunners": 5, "enemyBoxers": 0, "spawnTimer": 5},
	2: {"enemyRunners": 20, "enemyBoxers": 0, "spawnTimer": 2},
	3: {"enemyRunners": 0, "enemyBoxers": 10, "spawnTimer": 1},
	4: {"enemyRunners": 40, "enemyBoxers": 20, "spawnTimer": 0.2},
	5: {"enemyRunners": 100, "enemyBoxers": 30, "spawnTimer": 0.1},
}

func _ready():
	randomize()
	transition_to(State.LEVER)

func _process(delta):
	match state:
		State.SPAWNING:
			if enemyRunners > 0 or enemyBoxers > 0:
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
	var pick = randi_range(0, 1)
	var enemy_scene

	if enemyRunners <= 0 and pick == 0:
		pick = 1
	if enemyBoxers <= 0 and pick == 1:
		pick = 0

	if pick == 0:
		enemy_scene = ENEMY_RUNNER
		enemyRunners -= 1
	else:
		enemy_scene = ENEMY_BOXER
		enemyBoxers -= 1

	var instance = enemy_scene.instantiate()
	instance.global_position = get_random_spawn_location()
	get_tree().current_scene.get_node("Y_Sort").add_child(instance)

	if enemyRunners <= 0 and enemyBoxers <= 0:
		waveTimer.stop()  # <--- stop the timer here!
		transition_to(State.LEVER)
	else:
		transition_to(State.SPAWNING)

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
