extends CharacterBody2D

@onready var player = get_node("/root/World/Y_Sort/Player")
@onready var player_global_pos = player.global_position
var target_position
@onready var anim = $Blink
var health = 10

func _physics_process(delta):
	player_global_pos = player.global_position
	target_position = (player_global_pos - position).normalized()
	
	if position.distance_to(player_global_pos) > 3:
		move_and_slide()
		velocity = target_position * 40

	if health < 1:
		queue_free()
		
func _on_hurtbox_area_entered(area):
	if area.is_in_group("PlayerProjectile"):
		health = health - 1
		anim.play("blink")
