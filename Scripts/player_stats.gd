extends Node

@onready var health = Globals.globalHealth
@onready var maxhealth = Globals.globalMaxhealth
@onready var currentGun = Globals.globalCurrentGun



@onready var AR_pickup = get_node_or_null("/root/World/AR_pickup")
@onready var Pistol_pickup = get_node_or_null("/root/World/Pistol_pickup")
@onready var Shot_pickup = get_node_or_null("/root/World/Shot_pickup")
@onready var Mini_pickup = get_node_or_null("/root/World/Mini_pickup")

signal no_health
signal health_changed(value)
signal maxhealth_changed(value)
signal changed_current_gun(value)


func _process(delta):
	if Input.is_action_just_pressed(("ui_up")):
		if health < maxhealth:
			health = health+1
			Globals.globalHealth = Globals.globalHealth+1
			change_health(health)
			
		
	if Input.is_action_just_pressed(("ui_down")):
		if health > 0:
			health = health-1
			Globals.globalHealth = Globals.globalHealth-1
			change_health(health)
		
		
func change_max_health(value):
	maxhealth = value
	Globals.globalMaxhealth = value
	self.health = min(health,maxhealth)
	emit_signal("maxhealth_changed", maxhealth)

func change_health(value):
	health = value
	Globals.globalHealth = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		
func current_gun_changed(value):
	currentGun = value
	Globals.globalCurrentGun = value
	emit_signal("changed_current_gun", currentGun)

	
		
func _ready():
	#Engine.max_fps = 60 #sets the game to run at 60fps max
	health = Globals.globalHealth
	
	change_health(health)
	change_max_health(maxhealth)
	if AR_pickup != null:
		AR_pickup.AR_picked.connect(current_gun_changed)
	if Pistol_pickup != null:
		Pistol_pickup.Pistol_picked.connect(current_gun_changed)
	if Shot_pickup != null:
		Shot_pickup.Shot_picked.connect(current_gun_changed)
	if Mini_pickup != null:
		Mini_pickup.Mini_picked.connect(current_gun_changed)
