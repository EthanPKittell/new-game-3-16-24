extends CharacterBody2D



var speed = 2.3
var accuracyValue = 0.2#0.01 is pretty accurate 2.0 is insanely inaccurate
var canFire = false #I set it to false because when You start you have no gun
var fireRate = 0.2
var isShotgun = false
var stats = PlayerStats
var rollingVector = Vector2.ZERO
var can_roll = true
var isPoisoned = false

@onready var shotTimer = $Timer
@onready var rollTimer = $RollActive
@onready var playerSprite = $AnimatedSprite2D
@onready var playerHandsWeapon = $playerHands/AnimatedSprite2D
@onready var hurtBox = $Hurtbox

signal ammo_changed(value)
signal start_reload()

signal roll_started()
signal roll_ended()

enum {
	MOVING,
	ROLLING,
	SWORDSLASH,
	
}

var state = MOVING

func _ready():
	stats.no_health.connect(death)
	Globals.ammo_picked.connect(ammo_picked_up)
	Globals.weapon_picked.connect(change_gun)
	randomize()
	change_gun(Globals.globalCurrentGun)
	Globals.poisoned.connect(poisonEffect)
	
	Globals.playerRef = self
	

func spawn_shell(shell_type):
	var mouse_position = get_global_mouse_position()
	var shell_scene = preload("res://Scenes/bullet_shell.tscn")
	var shell = shell_scene.instantiate()

	var eject_offset = Vector2(10, -5)
	shell.facing_dir = 1 # +1 for right, -1 for left
	shell.casing_type = shell_type
	if mouse_position.x > self.global_position.x:
		eject_offset.x *= -1
		shell.facing_dir = -1 # +1 for right, -1 for left

	shell.global_position = global_position + eject_offset

	# Send player facing direction to shell
	
	
	get_tree().current_scene.add_child(shell)


func _physics_process(delta):
	
	if state == MOVING:
		if Input.is_action_pressed(("MOVE_RIGHT")): #Change logic for rolling movement later
			position.x += speed
			rollingVector.x = 1 
			if !(Input.is_action_pressed("MOVE_UP") || Input.is_action_pressed("MOVE_DOWN")):
				rollingVector.y = 0
			playerSprite.play("player_run")
		if Input.is_action_pressed(("MOVE_LEFT")):
			position.x -= speed
			rollingVector.x = -1
			if !(Input.is_action_pressed("MOVE_UP") || Input.is_action_pressed("MOVE_DOWN")):
				rollingVector.y = 0
			playerSprite.play("player_run")
		if Input.is_action_pressed(("MOVE_UP")):
			position.y -= speed
			rollingVector.y = -1
			if !(Input.is_action_pressed("MOVE_LEFT") || Input.is_action_pressed("MOVE_RIGHT")):
				rollingVector.x = 0
			playerSprite.play("player_run")
		if Input.is_action_pressed(("MOVE_DOWN")):
			position.y += speed
			rollingVector.y = 1
			if !(Input.is_action_pressed("MOVE_LEFT") || Input.is_action_pressed("MOVE_RIGHT")):
				rollingVector.x = 0
			playerSprite.play("player_run")
		if !Input.is_action_pressed(("MOVE_RIGHT")) && !Input.is_action_pressed(("MOVE_LEFT")) && !Input.is_action_pressed(("MOVE_UP")) && !Input.is_action_pressed(("MOVE_DOWN")):
			playerSprite.play("player_idle")
		if Input.is_action_just_pressed("ROLL_BUTTON") && can_roll == true: #this is going to be an implementation of a roll (need to figure out vectoring and roll ability)
			state = ROLLING
			hurtBox.monitorable = false
			hurtBox.monitoring = false
			can_roll = false
			emit_signal("roll_started")
			playerSprite.play("player_roll")
			
			
	
	if state == ROLLING: 
		position = position.move_toward(global_position + (rollingVector * 100), delta * 400)
		##explaination for these values the rolling vector multiplication is the target position and the delta mult is acceleration
	
	
	
	move_and_slide()
	
	if Input.is_action_pressed("BUTTON_LEFT") && state == MOVING:
		if canFire == true and Globals.bullets > 0:
			if isShotgun == true: #shotgun has multiple projectiles
				shoot()
				shoot()
				shoot()
				shoot()
				shoot()
				spawn_shell(1)
			elif Globals.globalCurrentGun == 5:
				playerHandsWeapon.play("sword")
				slash()
				state = SWORDSLASH
				playerSprite.play("player_idle")
			elif Globals.globalCurrentGun == 6:
				playerHandsWeapon.play("greatsword")
				slash()
				slash()
				state = SWORDSLASH
				playerSprite.play("player_idle")
			else:
				shoot()
				spawn_shell(0)
			Globals.bullets -=1
			Globals.emit_signal("clip_change", Globals.bullets)
			canFire = false
			
			shotTimer.wait_time = fireRate
			shotTimer.start()
		elif Globals.bullets == 0:
			pass #START RELOAD HERE
			emit_signal("start_reload")
			
	var mouse_position = get_global_mouse_position()
	
	if state == MOVING || state == SWORDSLASH:
		if mouse_position.x > self.global_position.x:
			playerSprite.flip_h = false
		elif mouse_position.x < self.global_position.x:
			playerSprite.flip_h = true
	if state == ROLLING:
		if rollingVector.x == 1:
			playerSprite.flip_h = false
		elif rollingVector.x == -1:
			playerSprite.flip_h = true
			
			
func shoot():
	
	#create smoke effect
	var smoke = preload("res://Scenes/smoke.tscn")
	var smokeEffect = smoke.instantiate()
	var world = get_tree().current_scene
	world.add_child(smokeEffect)
	smokeEffect.global_position = global_position
	smokeEffect.look_at(get_global_mouse_position())
	
	#create bullet
	var accuracy = Vector2(randf_range(-accuracyValue,accuracyValue), randf_range(-accuracyValue,accuracyValue))
	var bullet = preload("res://Scenes/player_bullet.tscn")
	var shot = bullet.instantiate()

	world.add_child(shot)
	shot.global_position = global_position
	shot.direction = (get_global_mouse_position() - self.global_position).normalized() + accuracy
	
	#this is for visual recoil
	if isShotgun == true || Globals.globalCurrentGun == 1: #this is only for shotgun as it has massive recoil
		if playerSprite.flip_h == false:
			playerHandsWeapon.rotation_degrees -= 5
		elif playerSprite.flip_h == true:
			playerHandsWeapon.rotation_degrees += 5
		playerHandsWeapon.position.x -= 2
	else:
		playerHandsWeapon.position.x -= 5
		
func slash():
	
	if Globals.globalCurrentGun == 6: #This is a crutch for the current frame system change to anim player
		await get_tree().create_timer(0.5).timeout
	var world = get_tree().current_scene
	#create slash
	var accuracy = Vector2(randf_range(-accuracyValue,accuracyValue), randf_range(-accuracyValue,accuracyValue))
	var slash = preload("res://Scenes/player_slash.tscn")
	var slashShot = slash.instantiate()

	world.add_child(slashShot)
	slashShot.global_position = global_position
	slashShot.direction = (get_global_mouse_position() - self.global_position).normalized() + accuracy
	
	
	
func _on_timer_timeout():
	canFire = true
	$Timer.stop()
	playerHandsWeapon.position = Vector2.ZERO
	playerHandsWeapon.rotation_degrees = 0
	if Globals.globalCurrentGun == 5:
		playerHandsWeapon.play("sword")
		playerHandsWeapon.stop()
		playerHandsWeapon.frame = 0
		state = MOVING
	if Globals.globalCurrentGun == 6:
		playerHandsWeapon.play("greatsword")
		playerHandsWeapon.stop()
		playerHandsWeapon.frame = 0
		state = MOVING
	
func change_gun(value):
	#Gun changing mechanics
	#pistol
	if value == 1:
		accuracyValue = 0.16
		fireRate = 0.3
		canFire = true
		isShotgun = false
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("pistol")
	#assault rifle
	elif value == 2:
		accuracyValue = 0.1
		fireRate = 0.1
		canFire = true
		isShotgun = false
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("AR")
	#shotgun
	elif value == 3:
		accuracyValue = 0.2
		fireRate = 0.5
		canFire = true
		isShotgun = true #adds more bullets to each shot
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("shotgun")
	elif value == 4:
		accuracyValue = 0.13
		fireRate = 0.04
		canFire = true
		isShotgun = false
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("mini_gun")
	#sword
	elif value == 5:
		accuracyValue = 0.13
		fireRate = 0.4
		Globals.playerDamage = 4
		canFire = true
		isShotgun = false
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("sword")
		playerHandsWeapon.stop()
		playerHandsWeapon.frame = 0
	#greatsword
	elif value == 6:
		accuracyValue = 0.2
		fireRate = 1.2
		Globals.playerDamage = 8
		canFire = true
		isShotgun = false
		emit_signal("ammo_changed", Globals.ammo)
		playerHandsWeapon.play("greatsword")
		playerHandsWeapon.stop()
		playerHandsWeapon.frame = 0
		
		
		
func ammo_picked_up(ammoAdded):
	print("Ammo got registered as picked up")
	emit_signal("ammo_changed", Globals.ammo + ammoAdded)
	Globals.ammo = Globals.ammo + ammoAdded
	#ammo_pickup.ammo_picked.disconnect(ammo_picked_up)


func _on_hurtbox_area_entered(area):
	if area.is_in_group("EnemyProjectile"):
		#stats.health = stats.health - 1
		stats.change_health(Globals.globalHealth - 1)
	if area.is_in_group("ammo_add"):
		emit_signal("ammo_changed", Globals.ammo)
		
		
		
func death():
	Globals.playerRef = null
	call_deferred("queue_free")
	

#not using this anymore
func _on_roll_active_timeout() -> void:
	can_roll = true


func _on_animated_sprite_2d_animation_finished() -> void:
	state = MOVING
	hurtBox.monitorable = true
	hurtBox.monitoring = true
	emit_signal("roll_ended")
	rollTimer.wait_time = 1.0
	rollTimer.start()

func poisonEffect():
	if isPoisoned == false:
		isPoisoned = true
		playerSprite.modulate = Color(0.376, 1, 0.153)
		playerHandsWeapon.modulate = Color(0.376, 1, 0.153)
		var poison = preload("res://Scenes/poison_effect.tscn")
		var poisonEffect = poison.instantiate()
		self.add_child(poisonEffect)
		poisonEffect.global_position = global_position
		for i in range(3):
			await get_tree().create_timer(5).timeout
			stats.change_health(Globals.globalHealth - 1)
		await get_tree().create_timer(5).timeout
		poisonEffect.queue_free()
		isPoisoned = false
		playerSprite.modulate = Color(1, 1, 1)
		playerHandsWeapon.modulate = Color(1, 1, 1)
		
