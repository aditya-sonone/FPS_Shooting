extends KinematicBody

var damage = 25
const CAM_SHAKE = 0.5

var speed = 5
var acceleration = 10
var gravity = 12
var jump = 5
var jump_num = 0
var mouse_sensitivity = 0.09

export var shoot_delay = 0.15

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var anim_player = $AnimationPlayer
onready var sound = $AudioStreamPlayer
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast
onready var timer = $Timer
onready var hp = preload("res://Hp.tscn")
onready var bullet_mark = preload("res://Bullet_mark.tscn")
onready var particle = preload("res://Partical_Effect.tscn")
onready var gun_fire = preload("res://Music/error_004.ogg")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func fire():
	if Input.is_action_pressed("fire"):
		if not anim_player.is_playing():
			camera.translation = lerp(camera.translation, Vector3(rand_range(CAM_SHAKE, -CAM_SHAKE), rand_range(CAM_SHAKE, -CAM_SHAKE), 0), 0.5)
			
			if raycast.is_colliding():
				var target = raycast.get_collider()
				
				if timer.is_stopped():
					var b = bullet_mark.instance()
					target.add_child(b)
					b.global_transform.origin = raycast.get_collision_point()
					b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				
				if target.is_in_group("Enemy") and timer.is_stopped():
					timer.start(shoot_delay)
					if target.is_in_group("Person"):
						var p = particle.instance()
						target.add_child(p)
						p.global_transform.origin = raycast.get_collision_point()
					target.health -= damage
					var h = hp.instance()
					h.get_child(0).value = target.health
					target.add_child(h)
						
		anim_player.play("GunFire")
		if !sound.is_playing():
			sound.stream = gun_fire
			sound.play()
			
	else:
		anim_player.stop()
		sound.stop()

func _physics_process(delta):
	fire()
	direction = Vector3()
	if is_on_floor():
		jump_num = 0
	
	if not is_on_floor():
		fall.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if jump_num == 0:
			fall.y = jump
			jump_num = 1
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			fall.y = jump
			jump_num = 2
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)

