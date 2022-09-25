extends StaticBody

var health = 150
export var time_delay = 0.2
onready var wall_sound = preload("res://Music/laserRetro_001.ogg")
onready var sound = $AudioStreamPlayer
onready var anim_player = $AnimationPlayer
onready var timer = $Timer

func _ready():
	timer.start(time_delay)
	anim_player.play("wall")
	sound.stream = wall_sound
	sound.play()

func _process(delta):
	if health <=0:
		queue_free()

func _on_Timer_timeout():
	sound.stop()
	#anim_player.stop()
