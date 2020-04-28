extends Area2D

const SPEED = 500

var velocity = Vector2()
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y = SPEED * delta * direction
	translate(velocity)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	# print(body.name)
	if body.has_method("hit"):
		body.rpc("hit")
		queue_free()

