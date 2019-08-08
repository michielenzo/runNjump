extends Area2D

var speed = 0

func _process(delta):
	position.x -= speed * delta
	speed += 0.1
