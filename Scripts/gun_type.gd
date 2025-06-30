extends Control

var currentGun = 0

@onready var gunIcon = $gunIcon
@onready var ammoLabel = $Ammo
@onready var Player = get_node_or_null("/root/World/Y_Sort/Player")
@onready var localPlayerStats =  get_node_or_null("/root/World/PlayerStats") #have to do this for the room updating
@onready var coinLabel = $Coins
@onready var gemLabel = $Gems
	
func gun_change(value):
	gunIcon.frame = value

func ammo_amount_change(value):
	ammoLabel.text = "%s" % [str(value)]
	
func coins_change(value):
	coinLabel.text = "%s" % [str(value)]
	Globals.playerCoins = value
	
func gems_change(value):
	gemLabel.text = "%s" % [str(value)]
	Globals.playerGems = value
	
func _ready():
	currentGun = PlayerStats.currentGun
	#just set up UI to have the starting values
	gun_change(currentGun)
	ammo_amount_change(Globals.ammo)
	coins_change(Globals.playerCoins)
	gems_change(Globals.playerGems)
	localPlayerStats.changed_current_gun.connect(gun_change)
	Globals.coin_picked.connect(coins_change)
	Globals.gem_picked.connect(gems_change)
	if Player != null:
		Player.ammo_changed.connect(ammo_amount_change)

#func _physics_process(delta): #fps counter
#	ammoLabel.text = str(Engine.get_frames_per_second())
