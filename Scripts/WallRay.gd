extends RayCast

onready var wall_pos = preload("res://Wall_Pos.tscn")

func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("action"):
		if not get_child(0):
			var wp = wall_pos.instance()
			add_child(wp)
		else:
			get_child(0).queue_free()
