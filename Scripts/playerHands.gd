extends Node2D


@onready var playerSprite = $AnimatedSprite2D
@onready var Player = get_node_or_null("/root/World/Y_Sort/Player")
@onready var hands = self

func roll_start_hide() -> void:
	hands.visible = false
	
func roll_start_unhide() -> void:
	hands.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var mouse_position = get_global_mouse_position()
	
	if mouse_position.x > self.global_position.x:
		playerSprite.scale.y = 1
	elif mouse_position.x < self.global_position.x:
		playerSprite.scale.y = -1
		
	look_at(get_global_mouse_position())

func _ready() -> void:
	playerSprite.play("default")
	if Player != null:
		Player.roll_started.connect(roll_start_hide)
		Player.roll_ended.connect(roll_start_unhide)
