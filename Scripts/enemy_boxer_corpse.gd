extends Node2D

@onready var corspeSprite = $Sprite2D
@onready var player = get_node("/root/World/Y_Sort/Player")
@onready var blood = $BloodEffect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	corspeSprite.modulate = Color(0.355, 0.355, 0.355)
	await get_tree().create_timer(2.0).timeout
	blood.emitting = false
	await get_tree().create_timer(10.0).timeout
	queue_free()
