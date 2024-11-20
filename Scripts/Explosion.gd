extends Node2D

@onready var anim = $AnimatedSprite2D


func _ready():
	var randoFlip = randi_range(0,1) # choose 0 or 1 to flip sprite makes effect more unique
	if randoFlip == 0:
		$AnimatedSprite2D.flip_h = true
	anim.play("default")
	


func _on_animated_sprite_2d_animation_finished():
	queue_free()
