extends Area2D

var speed = 0
var speed_offset = 50
var random_speed_offset = 300

func _enter_tree():
	var random_offset = randi() % random_speed_offset + 1
	speed += speed_offset + random_offset

func _process(delta):
	position.x -= speed * delta
	speed += 0.1

