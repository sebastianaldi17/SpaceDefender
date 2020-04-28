extends Node2D

# Declare member variables here. Examples:
puppet var score = 0

sync func update_score(inc):
	score += inc
	$Control/Label.text = "Score: " + str(score)

func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Players.get_child_count() <= 0 or $Enemies.get_child_count() <= 1:
		$Enemies.visible = false
		$Control/EndMessage.visible = true
		$Control/ScoreMessage.visible = true
		$Control/Button.visible = true
		$Control/ScoreMessage.text = "Your score: " + str(score)
		if $Enemies.get_child_count() <= 1:
			$Control/EndMessage.text = "You win!"

func _on_Button_pressed():
	gamestate.end_game()
