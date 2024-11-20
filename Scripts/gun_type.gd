extends Control

var currentGun = 0

@onready var gunIcon = $gunIcon
@onready var ammoLabel = $Ammo
@onready var Player = get_node_or_null("/root/World/Y_Sort/Player")
@onready var localPlayerStats =  get_node_or_null("/root/World/PlayerStats") #have to do this for the room updating

	
func gun_change(value):
	gunIcon.frame = value

func ammo_amount_change(value):
	ammoLabel.text = "%s" % [str(value)]
	
	
func _ready():
	currentGun = PlayerStats.currentGun
	gun_change(currentGun)
	ammo_amount_change(Globals.ammo)
	localPlayerStats.changed_current_gun.connect(gun_change)
	if Player != null:
		Player.ammo_changed.connect(ammo_amount_change)

#func _physics_process(delta): #fps counter
#	ammoLabel.text = str(Engine.get_frames_per_second())
