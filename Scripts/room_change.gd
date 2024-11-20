extends Area2D


@export var roomPath = "res://Scenes/Stage1.tscn"



func _on_body_entered(body):
	get_tree().change_scene_to_file(roomPath)
