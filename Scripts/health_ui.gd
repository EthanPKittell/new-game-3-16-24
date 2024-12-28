extends Control

var health = 5#:
	#set(value): set_health(value)
var maxhealth = 5#:
	#set(value): set_max_health(value)

@onready var heartUIFull = $healthbarFull
@onready var heartUIEmpty = $healthbarEmpty

	

func set_health(value):
	health = clamp(value, 0, maxhealth)
	if heartUIFull != null:
		heartUIFull.size.x = health * 64

func set_max_health(value):
	maxhealth = max(value, 1)
	self.health = min(health, maxhealth)
	if heartUIEmpty != null:
		heartUIEmpty.size.x = maxhealth * 64
		
func _ready():
	health = Globals.globalHealth
	maxhealth = Globals.globalMaxhealth
	set_health(health)
	set_max_health(maxhealth)
	PlayerStats.health_changed.connect(set_health)
	PlayerStats.maxhealth_changed.connect(set_max_health)
