extends KinematicBody

onready var player = get_parent().get_node("Player")
onready var ray = $Head/RayCast
var health = 100
var gravity = 12
var fall = Vector3()
var speed = 20

func _ready():
	pass
	
func _physics_process(delta):
	look_at(player.global_transform.origin, Vector3.UP)
	if ray.is_colliding():
		var target = ray.get_collider()
		if target.is_in_group("Player"):
			var pos = (ray.get_collision_point()-global_transform.origin) * 2
			move_and_slide(pos * speed * delta, Vector3.UP)
		
	

func _process(delta):
	if not is_on_floor():
		$Timer.start()
		fall.y -= gravity * delta
		move_and_slide(fall, Vector3.UP)
		if $Timer.is_stopped():
			queue_free()
	if health <= 0:
		queue_free()
