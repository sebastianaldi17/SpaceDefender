extends KinematicBody2D

const BULLET = preload("res://EnemyBullet.tscn")
const b_sound = preload("res://src/sfx/laser.wav")

sync func shoot():
	var bullet = BULLET.instance()
	bullet.global_position = $bullet_source.global_position
	get_node("../..").add_child(bullet)
	$AudioStreamPlayer2D.stream = b_sound
	$AudioStreamPlayer2D.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

sync func call_death():
	get_parent().get_parent().update_score(10)
	$AnimationPlayer.play("die")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass