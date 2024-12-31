extends Node2D

@onready var anim = $PoisonCloud


func _ready():
	var randoFlip = randi_range(0,1) # choose 0 or 1 to flip sprite makes effect more unique
	if randoFlip == 0:
		anim.flip_h = true
	anim.play("default")
	


func _on_poison_cloud_animation_finished() -> void:
	queue_free()
