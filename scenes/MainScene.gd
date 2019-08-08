extends Node2D

var cactus_scene = preload("res://scenes/Cactus.tscn")
var bird_scene = preload("res://scenes/Bird.tscn")
var obstacle_y = 550
var obstacle_x_offset = 400
var screen_width
var gameOver = false
var wait_time_modulo = 4
var obstacle_spawn_time_reduction = 0
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

func _on_LevelManager_level_up(level):
	obstacle_spawn_time_reduction = $LevelManager.level_settings[level].obstacle_spawn_time_reduction

func _on_ObstacleSpawnTimer_timeout():
	var wait_time_offset_variation = 5
	var wait_time_minimum = 2.5
	var random_wait_time = (randi() % wait_time_offset_variation + wait_time_minimum) - obstacle_spawn_time_reduction
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
	var n_birds = $LevelManager.level_settings[$LevelManager.level].birds_in_bird_flock
	for i in range(n_birds):
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
	$HUD/ScoreCounter/ScoreTimer.start()
	$HUD.show()
	$Player.game_started = true
	$TileMap.game_started = true
	$LevelManager.game_started = true
	spawn_obstacle()
