extends Spatial

onready var wallray = get_parent()
onready var wallray_owner = get_parent().get_owner()
onready var wall = preload("res://Wall.tscn")

func _ready():
	set_as_toplevel(true)
	global_transform.origin = wallray.get_collision_point()
	

func _input(event):
	if Input.is_action_just_released("action"):
		var w = wall.instance()
		w.global_transform = global_transform
		get_tree().get_root().add_child(w)
		queue_free()

func _process(delta):
	global_transform.origin = wallray.get_collision_point()
	rotation = wallray_owner.rotation
	
