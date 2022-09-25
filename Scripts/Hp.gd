extends Control

func _ready():
	pass

func _on_Hp_timer_timeout():
	queue_free()
