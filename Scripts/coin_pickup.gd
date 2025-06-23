extends Node2D

var followPlayer = false

@onready var anim = $Sprite2D

@onready var player = get_node("/root/World/Y_Sort/Player")

func _ready() -> void:
	anim.play("default")

func _on_ammo_pickup_area_body_entered(body):
	if body.is_in_group("Player"):
		#if Globals.globalHealth < Globals.globalMaxhealth:
		#	Globals.emit_signal("health_picked", Globals.globalHealth+1)
		queue_free()

func _on_attract_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		followPlayer = true


func _process(_delta: float) -> void:
	if followPlayer == true:
		position = position.move_toward(player.global_position, _delta * 230)
		##	velocity += softCollision.get_push_vector() * 20
