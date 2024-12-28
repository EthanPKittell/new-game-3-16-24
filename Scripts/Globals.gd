extends Node

var globalHealth = 5
var globalMaxhealth = 5
var globalCurrentGun = 0
var ammo = 0
var playerDamage = 1

#for ammo packs with varying ammo additions
signal ammo_picked(value)

#for health packs with varying health additions
signal health_picked(value)

#weapon values right now
#1 is pistol
#2 is assault rifle
#3 is shotgun
#4 is minigun
signal weapon_picked(value)

#func ammo_was_pickedup():
#	emit_signal("ammo_picked", 50)
#	pass
