extends Label

var score = 0

func _on_ScoreTimer_timeout():
	score += 1
	text = str(score)
