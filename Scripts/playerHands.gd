extends Node2D

@onready var playerSprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var mouse_position = get_global_mouse_position()
	
	if mouse_position.x > self.global_position.x:
		playerSprite.scale.y = 1
	elif mouse_position.x < self.global_position.x:
		playerSprite.scale.y = -1
		
	look_at(get_global_mouse_position())
