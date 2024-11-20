extends Area2D

var AR_stat = 1

signal Shot_picked(value)

func Shot_was_pickedup():
	emit_signal("Shot_picked", 3)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Globals.ammo = 15
		Shot_was_pickedup()
		queue_free()
