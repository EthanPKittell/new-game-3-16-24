extends Node2D

@onready var expire = $Expire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expire.wait_time = 30
	expire.start()


func _on_expire_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		Globals.emit_signal("poisoned")
