extends Node2D


var entered = false
@onready var itemAnimation = $AnimatedSprite2D
@onready var playerStats = get_node_or_null("/root/World/PlayerStats")
@onready var player = get_node("/root/World/Y_Sort/Player")
var purchaseLevel = 0


var state = 0 #0 is for damage, 1 is for attack speed, 2 is for max health and 3 is for speed

func _on_area_2d_body_entered(body):
	entered = true


func _on_area_2d_body_exited(body):
	entered = false
	
func _physics_process(delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept") && purchaseLevel < 5:
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
	pass
	#print(state)
