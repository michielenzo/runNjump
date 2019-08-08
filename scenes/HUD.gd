extends Control

func _on_LevelManager_level_up(level):
	$LevelLabel.text = "Level: " + str(level)
