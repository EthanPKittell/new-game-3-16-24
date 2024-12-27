extends Area2D

#var AR_stat = 1 #change all of this

signal ammo_picked(value)

func ammo_was_pickedup():
	emit_signal("ammo_picked", 50)
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		ammo_was_pickedup()
		queue_free()
