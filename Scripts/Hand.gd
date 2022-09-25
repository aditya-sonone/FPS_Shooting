extends Spatial

var mouse_move
var mouse_move_y
var sway_threshold = 5
var sway_lerp = 5

export var sway_left : Vector3
export var sway_right : Vector3
export var sway_up : Vector3
export var sway_down : Vector3
export var sway_nornal : Vector3

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = -event.relative.x
		mouse_move_y = -event.relative.y

func _physics_process(delta):
	if mouse_move != null:
		if mouse_move > sway_threshold:
			rotation = rotation.linear_interpolate(sway_left, sway_lerp * delta)
		elif mouse_move < -sway_threshold:
			rotation = rotation.linear_interpolate(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.linear_interpolate(sway_nornal, sway_lerp * delta)
	if mouse_move_y != null:
		if mouse_move_y > sway_threshold:
			rotation = rotation.linear_interpolate(sway_down, sway_lerp * delta)
		elif mouse_move_y < -sway_threshold:
			rotation = rotation.linear_interpolate(sway_up, sway_lerp * delta)
		else:
			rotation = rotation.linear_interpolate(sway_nornal, sway_lerp * delta)
	
