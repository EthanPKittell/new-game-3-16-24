extends Control

var currentGun = 0

@onready var gunIcon = $gunIcon
@onready var ammoLabel = $Ammo
@onready var Player = get_node_or_null("/root/World/Y_Sort/Player")
@onready var localPlayerStats =  get_node_or_null("/root/World/PlayerStats") #have to do this for the room updating
@onready var coinLabel = $Coins
@onready var gemLabel = $Gems
@onready var clipLabel = $Clip

func gun_change(value):
	gunIcon.frame = value

func ammo_amount_change(value):
	ammoLabel.text = "%s" % [str(value)]
	
func coins_change(value):
	coinLabel.text = "%s" % [str(value)]
	Globals.playerCoins = value

func bullets_change(value):
	if value == -1:
		value = INF
	clipLabel.text = "[font_size=24]%s/%s[/font_size]" % [str(value),str(Globals.clip)]
	
	
func gems_change(value):
	gemLabel.text = "%s" % [str(value)]
	Globals.playerGems = value
	
func _ready():
	currentGun = PlayerStats.currentGun
	clipLabel.bbcode_enabled = true
	#just set up UI to have the starting values
	gun_change(currentGun)
	ammo_amount_change(Globals.ammo)
	coins_change(Globals.playerCoins)
	gems_change(Globals.playerGems)
	bullets_change(Globals.bullets)
	
	localPlayerStats.changed_current_gun.connect(gun_change)
	Globals.coin_picked.connect(coins_change)
	Globals.gem_picked.connect(gems_change)
	Globals.clip_change.connect(bullets_change)
	if Player != null:
		Player.ammo_changed.connect(ammo_amount_change)

#func _physics_process(delta): #fps counter
#	ammoLabel.text = str(Engine.get_frames_per_second())
