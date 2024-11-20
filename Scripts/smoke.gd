extends Node2D


@onready var anim = $AnimatedSprite2D


func _ready():
	look_at(get_global_mouse_position())
	anim.play("smoke")
	


	


func _on_animated_sprite_2d_animation_finished():
	queue_free()
