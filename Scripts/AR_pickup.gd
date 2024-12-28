extends Area2D

var AR_stat = 1

signal AR_picked(value)

func AR_was_pickedup():
	emit_signal("AR_picked", 2)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Globals.ammo = 50
		#AR_was_pickedup()
		Globals.emit_signal("weapon_picked", 2)
		queue_free()
