extends Area2D

signal game_over

var game_started = false

enum {IDLE,JUMPING,SLIDING}
var state = IDLE

var velocity = 0
const jump_velocity = 18
const grav = 0.7
const run_acceleration_speed = 0.005

func _process(delta):
	apply_gravity(delta)
	process_input()
	run_acceleration()

func process_input():
	if Input.is_action_just_pressed("ui_up") && state == IDLE:
		jump()
	if Input.is_action_just_pressed("ui_down") && state != JUMPING:
		enter_slide()
	if Input.is_action_just_released("ui_down") && state != JUMPING:
		release_slide()

func _on_Cactus_area_entered(area):
	emit_signal("game_over")
	$ScreamSoundPlayer.play()

func _on_Bird_area_entered(area):
	emit_signal("game_over")
	$ScreamSoundPlayer.play()
	
func run_acceleration():
	if game_started:
		var current_animation_speed = $AnimatedSprite.frames.get_animation_speed("running")
		$AnimatedSprite.frames.set_animation_speed("running",current_animation_speed + run_acceleration_speed)	

func apply_gravity(delta):
	position.y += velocity
	velocity += grav
	if is_colliding_with_floor():
		if state == JUMPING:
			$AnimatedSprite.play()
			state = IDLE
		if state == SLIDING:
			position.y = 575
		else:	
			position.y = 550

func jump():
	velocity = -jump_velocity
	$AnimatedSprite.rotation_degrees = 0
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(4)
	$JumpSoundPlayer.play()
	state = JUMPING

func enter_slide():
	$AnimatedSprite.stop()
	$AnimatedSprite.set_frame(4)
	$AnimatedSprite.rotation_degrees = 53
	state = SLIDING

func release_slide():
	$AnimatedSprite.play()
	$AnimatedSprite.set_frame(4)
	$AnimatedSprite.rotation_degrees = 0
	state = IDLE

func is_colliding_with_floor():
	return position.y > 550
