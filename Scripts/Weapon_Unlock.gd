extends Area2D

@onready var pickupSprite = $Sprite2D
@onready var descriptionLabel = $"Item description"
@onready var costLabel = $"Item Cost"
var AR_stat = 1
@export var weapon_name: String = "UltraSword"
@export var description: String = "temp"
@export var weapon_id: int = 6
@export var cost: int = 15
@export var starting_clip: int = -1 # -1 means infinite, any positive number is finite
@export var starting_ammo: int = -1  # -1 means infinite, any positive number is finite
var entered = false


func _ready() -> void:
	pickupSprite.modulate = Color(0.111, 0.111, 0.111)
	descriptionLabel.bbcode_enabled = true
	if Globals.is_item_unlocked(weapon_name):
		pickupSprite.modulate = Color(1.0, 1.0, 1.0)
		
func weapon_was_pickedup():
	Globals.emit_signal("weapon_picked", weapon_id)
	Globals.emit_signal("clip_change",starting_clip)

func setupAmmo():
	if starting_ammo == -1:
		Globals.ammo = INF
	else:
		Globals.ammo = starting_ammo
		
	if starting_clip == -1:
		Globals.clip = INF
		Globals.bullets = INF
	else:
		Globals.clip = starting_clip
		Globals.bullets = starting_clip

func _on_body_entered(body):
	entered = true
	if body.is_in_group("Player") && Globals.is_item_unlocked(weapon_name):
		setupAmmo()
		weapon_was_pickedup()

func _process(delta: float) -> void:
	costLabel.visible = false
	descriptionLabel.visible = false
	if entered == true:
		if !Globals.is_item_unlocked(weapon_name):
			costLabel.visible = true
			descriptionLabel.visible = true
			descriptionLabel.text = "[b]%s[/b]\n[font_size=10]%s[/font_size]" % [weapon_name, description]
			costLabel.text = "%s Gems" % [str(cost)]
			if Input.is_action_just_released("ACCEPT_BUTTON") && Globals.playerGems >= cost:
				pickupSprite.modulate = Color(1.0, 1.0, 1.0)
				setupAmmo()
				weapon_was_pickedup()
				Globals.emit_signal("gem_picked", Globals.playerGems-cost)
				Globals.unlock_item(weapon_name)  #Do this when the purchase is made and the weapon is unlocked
				#queue_free()


func _on_body_exited(body):
	entered = false
	
