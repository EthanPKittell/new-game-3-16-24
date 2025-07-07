extends Control

var currentGun = 0

@onready var gunIcon = $gunIcon
@onready var ammoLabel = $Ammo
@onready var Player = get_node_or_null("/root/World/Y_Sort/Player")
@onready var localPlayerStats =  get_node_or_null("/root/World/PlayerStats") #have to do this for the room updating
@onready var coinLabel = $Coins
@onready var gemLabel = $Gems
@onready var clipLabel = $Clip
@onready var reload_bar = $ReloadBar

var reload_time = 1.5  # seconds
var reload_elapsed = 0.0
var reloading = false

func gun_change(value):
	gunIcon.frame = value

func ammo_amount_change(value):
	ammoLabel.text = "%s" % [str(value)]

func coins_change(value):
	coinLabel.text = "%s" % [str(value)]
	Globals.playerCoins = value
	
func reload_bar_start():
	if reloading:
		return

	reloading = true
	reload_time = Globals.reload_time
	reload_elapsed = 0.0
	reload_bar.value = 0
	reload_bar.visible = true

func _process(delta):
	if reloading:
		reload_elapsed += delta
		reload_bar.value = reload_elapsed / reload_time

		if reload_elapsed >= reload_time:
			reloading = false
			reload_bar.visible = false
			do_reload()

func do_reload():
	#ammount I will reload
	var to_reload = min(Globals.clip, Globals.ammo)
	Globals.bullets += to_reload
	Globals.ammo -= to_reload
	Player.emit_signal("ammo_changed", Globals.ammo)
	Globals.emit_signal("clip_change", Globals.bullets)
	
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
	Player.start_reload.connect(reload_bar_start)
	Globals.clip_change.connect(bullets_change)
	if Player != null:
		Player.ammo_changed.connect(ammo_amount_change)

#func _physics_process(delta): #fps counter
#	ammoLabel.text = str(Engine.get_frames_per_second())
