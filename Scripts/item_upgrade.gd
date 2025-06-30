extends Node2D


var entered = false
@onready var itemAnimation = $AnimatedSprite2D
@onready var itemLabel = $"Item description"
@onready var itemCostLabel = $"Item Cost"
@onready var playerStats = get_node_or_null("/root/World/PlayerStats")
@onready var player = get_node("/root/World/Y_Sort/Player")
var purchaseLevel = 1
var cost = 10


var state = 0 #0 is for damage, 1 is for attack speed, 2 is for max health and 3 is for speed

func _on_area_2d_body_entered(body):
	entered = true


func _on_area_2d_body_exited(body):
	entered = false
	
func _physics_process(delta):
	itemLabel.visible = false
	itemCostLabel.visible = false
	if entered == true:
		if purchaseLevel < 6:
			itemCostLabel.visible = true
			itemCostLabel.text = "%s Gold Coins" % [str(cost * purchaseLevel)]
		itemLabel.visible = true
		if Input.is_action_just_released("ACCEPT_BUTTON") && purchaseLevel < 6 && Globals.playerCoins >= cost * purchaseLevel:
			
			#Make purchase
			var charge = cost * purchaseLevel
			Globals.emit_signal("coin_picked", Globals.playerCoins-charge)
			print(Globals.playerCoins)
			itemAnimation.frame += 1
			purchaseLevel += 1
			
			match state:
				0:
					Globals.playerDamage +=1
				1:
					player.fireRate -= 0.005
				2:
					if Globals.globalHealth < Globals.globalMaxhealth+1:
						Globals.globalHealth += 1
					Globals.globalMaxhealth += 1
					PlayerStats.change_max_health(Globals.globalMaxhealth)
					PlayerStats.change_health(Globals.globalHealth)
				3:
					player.speed += 0.25
			
func _ready():
	match state:
		0:
			#DAMAGE
			itemLabel.text = "Damage Upgrade"#%s" % [str(value)]
			
		1:
			#FIRE RATE
			itemLabel.text = "Rate Of Fire Upgrade"
		2:
			#MAX HEALTH
			itemLabel.text = "Maximum Health Upgrade"
		3:
			#SPEED
			itemLabel.text = "Player Speed Upgrade"
	#print(state)
