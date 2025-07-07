extends Node

var globalHealth = 5
var globalMaxhealth = 5
var globalCurrentGun = 0
var ammo = 0
var clip = 0
var bullets = 0
var reload_time = 0
var playerDamage = 1
var playerCoins = 999
var playerGems = 999
var unlocked_items := {}

var playerRef: Node2D = null

func unlock_item(item_name: String) -> void:
	unlocked_items[item_name] = true
	
func is_item_unlocked(item_name: String) -> bool:
	return unlocked_items.get(item_name, false)

#for ammo packs with varying ammo additions
signal ammo_picked(value)

#for changing clip sizes
signal clip_change(value)

#for health packs with varying health additions
signal health_picked(value)

#weapon values right now
#1 is pistol
#2 is assault rifle
#3 is shotgun
#4 is minigun
signal weapon_picked(value)

signal poisoned()

#signals for currency (coin and gem)
signal coin_picked(value)
signal gem_picked(value)
