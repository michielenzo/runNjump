extends Node

signal level_up

var game_started = false
var level = 0

const level_settings = [{
	level = 0,
	birds_in_bird_flock = 1,
	obstacle_spawn_time_reduction = 0
},{
	level = 1,
	birds_in_bird_flock = 2,
	obstacle_spawn_time_reduction = 0.5
},{
	level = 2,
	birds_in_bird_flock = 3,
	obstacle_spawn_time_reduction = 1
},{
	level = 3,
	birds_in_bird_flock = 3,
	obstacle_spawn_time_reduction = 1.5
},{
	level = 4,
	birds_in_bird_flock = 4,
	obstacle_spawn_time_reduction = 2
},{
	level = 5,
	birds_in_bird_flock = 4,
	obstacle_spawn_time_reduction = 2.3	
}]

func _ready():
	$LevelUpTimer.start()

func _on_LevelUpTimer_timeout():
	level += 1
	if level <= level_settings.size():
		emit_signal("level_up", level)
