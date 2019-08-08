extends Node2D

var cactus_scene = preload("res://scenes/Cactus.tscn")
var bird_scene = preload("res://scenes/Bird.tscn")
var obstacle_y = 550
var obstacle_x_offset = 400
var screen_width
var gameOver = false
var wait_time_modulo = 4
var speed_up_spawner = 0
var score = 0

enum Obstacles{CACTUS, BIRD}
var cactus_spawn_change = 80

func _ready():
	randomize()
	screen_width = get_viewport().get_visible_rect().size

func _on_game_over():
	if !gameOver:
		gameOver = true
		$HUD.hide()
		$HUD/ScoreCounter/ScoreTimer.stop()
		$GameOverScreen/Score.text = "Score: " + str($HUD/ScoreCounter.score)
		$GameOverScreen.show()
		$HUD/ScoreCounter.score = 0
		$Player/AnimatedSprite.frames.set_animation_speed("running", 10)

func _on_TimerExponential_timeout():
	if speed_up_spawner == 0:
		speed_up_spawner = 1
	elif speed_up_spawner == 1:
		speed_up_spawner = 1.5
	elif speed_up_spawner == 1.5:
		speed_up_spawner = 2
	elif speed_up_spawner == 2:
		speed_up_spawner = 2.3		
		$ObstacleSpawnTimer/TimerExponential.stop()	
	print("spawn speed increased")

func _on_ObstacleSpawnTimer_timeout():
	var wait_time_offset_variation = 5
	var wait_time_minimum = 2.5
	var random_wait_time = (randi() % wait_time_offset_variation + wait_time_minimum) - speed_up_spawner
	print(random_wait_time)
	$ObstacleSpawnTimer.stop()
	$ObstacleSpawnTimer.wait_time = random_wait_time
	$ObstacleSpawnTimer.start()
	spawn_obstacle()

func spawn_obstacle():
	var random_number_under_hundred = randi()%101
	if random_number_under_hundred <= cactus_spawn_change:
		spawn_cactus()
	else:
		spawn_bird()

func spawn_bird():
	for i in range(3):
		var bird = bird_scene.instance()
		var rand_height_diff = randi() % 20 + 20
		var rand_x_diff = 100 - randi() % 200
		bird.connect("area_entered", $Player, "_on_Bird_area_entered")
		bird.position.y = 520 - i * rand_height_diff
		bird.position.x = 1300 + rand_x_diff
		bird.speed = $TileMap.floor_speed
		add_child(bird)
	print("spawn bird!")

func spawn_cactus():
	var cactus = cactus_scene.instance()
	cactus.connect("area_entered", $Player, "_on_Cactus_area_entered")
	cactus.position.y = 550
	cactus.position.x = 1300
	cactus.speed = $TileMap.floor_speed
	add_child(cactus)	

func _on_Menu_start_game():
	$ObstacleSpawnTimer.start()
	$ObstacleSpawnTimer/TimerExponential.start()
	$HUD/ScoreCounter/ScoreTimer.start()
	$HUD.show()
	$Player.game_started = true
	$TileMap.game_started = true
	spawn_obstacle()
	pass 
