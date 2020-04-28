extends KinematicBody2D

puppet var pos = Vector2()
puppet var velocity = Vector2()

export var dead = false
const BULLET = preload("res://Bullet.tscn")
const b_sound = preload("res://src/sfx/laser.wav")
const d_sound = preload("res://src/sfx/Explosion.wav")

sync func shoot(pos):
	var bullet = BULLET.instance()
	bullet.global_position = pos
	get_node("../..").add_child(bullet)
	$AudioStreamPlayer2D.stream = b_sound
	$AudioStreamPlayer2D.play()
	
puppet func die():
	$DeathNoise.stream = d_sound
	$DeathNoise.play()
	dead = true
	
master func hit():
	if dead:
		return
	rpc("die")
	die()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# $Sprite.modulate = Color(randf(), randf(), randf())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var motion = Vector2()
	if dead:
		$CollisionPolygon2D.disabled = true
		$AnimationPlayer.play("died")
	elif is_network_master():
		if $MoveTimer.time_left <= 0:
			if Input.is_action_pressed("ui_left"):
				motion.x = -1
			elif Input.is_action_pressed("ui_right"):
				motion.x = 1
			else:
				motion.x = 0
			if Input.is_action_pressed("ui_up"):
				motion.y = -1
			elif Input.is_action_pressed("ui_down"):
				motion.y = 1
			else:
				motion.y = 0
		if Input.is_action_just_pressed("shoot"):
			rpc("shoot", $bullet_source.global_position)
		motion *= 4
		rset("velocity", motion)
		rset("pos", position)
	else:
		position = pos
		motion = velocity
	var collided = move_and_collide(motion)
	if collided:
		if collided.collider.has_method("shoot"):
			hit()
	if not is_network_master():
		pos = position	
	

func set_player_name(new_name):
	get_node("Label").set_text(new_name)

func _on_Timer_timeout():
	$CollisionPolygon2D.disabled = false
	pass
