extends Area2D

var AR_stat = 1

signal Pistol_picked(value)

func Pistol_was_pickedup():
	emit_signal("Pistol_picked", 1)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Globals.ammo = 20
		#Pistol_was_pickedup()
		Globals.emit_signal("weapon_picked", 1)
		queue_free()
