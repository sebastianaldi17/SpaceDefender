extends Node2D

var dir = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().find_node("Players").get_child_count() > 0:
		var movement = Vector2(0.5, 0)
		for node in get_children():
			if "Enemy" in node.name:
				if node.find_node("R").is_colliding():
					dir = -1
					movement.y = 2
				if node.find_node("L").is_colliding():
					movement.y = 2
					dir = 1
		movement.x *= dir
		translate(movement)

func _on_Timer_timeout():
	if is_network_master():
		if get_parent().find_node("Players").get_child_count() > 0:
			var l = []
			for node in get_children():
				if "Enemy" in node.name:
					l.append(node)
			if l.size() > 0:
				var index = randi()%l.size()
				l[index].shoot()
				l[index].rpc("shoot")
			$Timer.start(1)
