extends Area2D

@onready var pickupSprite = $Sprite2D
@onready var costLabel = $"Item Cost"
var AR_stat = 1
@export var weapon_name: String = "UltraSword"
@export var weapon_id: int = 6
@export var cost: int = 15
@export var starting_ammo: int = -1  # -1 means infinite, any positive number is finite
var entered = false


func _ready() -> void:
	pickupSprite.modulate = Color(0.111, 0.111, 0.111)
	if Globals.is_item_unlocked(weapon_name):
		pickupSprite.modulate = Color(1.0, 1.0, 1.0)
		
func weapon_was_pickedup():
	Globals.emit_signal("weapon_picked", weapon_id)

func setupAmmo():
	if starting_ammo == -1:
		Globals.ammo = INF
	else:
		Globals.ammo = starting_ammo

func _on_body_entered(body):
	entered = true
	if body.is_in_group("Player") && Globals.is_item_unlocked(weapon_name):
		setupAmmo()
		weapon_was_pickedup()

func _process(delta: float) -> void:
	costLabel.visible = false
	if entered == true:
		if !Globals.is_item_unlocked(weapon_name):
			costLabel.visible = true
			costLabel.text = "%s only %s gems!" % [weapon_name,str(cost)]
			if Input.is_action_just_released("ACCEPT_BUTTON") && Globals.playerGems >= cost:
				pickupSprite.modulate = Color(1.0, 1.0, 1.0)
				setupAmmo()
				weapon_was_pickedup()
				Globals.emit_signal("gem_picked", Globals.playerGems-cost)
				Globals.unlock_item(weapon_name)  #Do this when the purchase is made and the weapon is unlocked
				#queue_free()


func _on_body_exited(body):
	entered = false
	
