extends Area2D


@export var roomPath: PackedScene


func _on_body_entered(body):
	call_deferred("_change_room")

	
func _change_room():
	get_tree().change_scene_to_packed(roomPath)
