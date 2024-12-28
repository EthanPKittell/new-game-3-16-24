extends Node

@onready var health = Globals.globalHealth
@onready var maxhealth = Globals.globalMaxhealth
@onready var currentGun = Globals.globalCurrentGun


signal no_health
signal health_changed(value)
signal maxhealth_changed(value)
signal changed_current_gun(value)


func _process(delta):
	if Input.is_action_just_pressed(("ui_up")):
		pass
		#if Globals.globalHealth < Globals.globalMaxhealth:#health < maxhealth:
		#	#health = health+1
		#	change_health(Globals.globalHealth+1)#health)
			
			
		
	if Input.is_action_just_pressed(("ui_down")):
		pass
		#if Globals.globalHealth > 0:#health > 0:
		#	#health = health-1
		#	change_health(Globals.globalHealth-1)#health)
		
		
func change_max_health(value):
	#maxhealth = value
	Globals.globalMaxhealth = value
	#self.health = min(health,maxhealth)
	Globals.globalHealth = min(Globals.globalHealth,Globals.globalMaxhealth)
	emit_signal("maxhealth_changed", Globals.globalMaxhealth)
	emit_signal("health_changed", Globals.globalHealth)
	print("This is the maxHealth: ", Globals.globalMaxhealth)

func change_health(value):
	#health = value
	Globals.globalHealth = value
	emit_signal("health_changed", Globals.globalHealth)
	if Globals.globalHealth <= 0:#health <= 0:
		emit_signal("no_health")
	print("This is the Health: ", Globals.globalHealth)
		
func current_gun_changed(value):
	currentGun = value
	Globals.globalCurrentGun = value
	emit_signal("changed_current_gun", currentGun)

	
		
func _ready():
	#Engine.max_fps = 60 #sets the game to run at 60fps max
	#health = Globals.globalHealth
	
	change_health(Globals.globalHealth)#might need to flip these
	change_max_health(Globals.globalHealth)
	Globals.weapon_picked.connect(current_gun_changed)
	Globals.health_picked.connect(change_health)
	
