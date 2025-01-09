extends Area2D

var AR_stat = 1

signal Mini_picked(value)

func Mini_was_pickedup():
	emit_signal("Mini_picked", 4)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Globals.ammo = INF
		#Mini_was_pickedup()
		Globals.emit_signal("weapon_picked", 6)
		queue_free()
