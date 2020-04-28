extends Node2D

var dir = 1
var boost = false
puppet var pos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_network_master():
		var base = 1
		if boost:
			base = 5
		var movement = Vector2(base, 0)
		for node in get_children():
			if "Enemy" in node.name:
				if node.find_node("R").is_colliding():
					dir = -1
					movement.y = 2
					if boost: movement.y += 8
					break
				if node.find_node("L").is_colliding():
					movement.y = 2
					dir = 1
					if boost: movement.y += 8
					break
		movement.x *= dir
		translate(movement)
		rset("pos", position)
	else:
		position = pos

func _on_Timer_timeout():
	if is_network_master():
		if get_parent().find_node("Players").get_child_count() > 0:
			var l = []
			for node in get_children():
				if "Enemy" in node.name:
					if node.find_node("ScreenCheck").is_on_screen():
						l.append(node)
			if l.size() > 0:
				var index = randi()%l.size()
				# l[index].shoot()
				l[index].rpc("shoot")
			boost = true
			for b in get_parent().find_node("Area2D").get_overlapping_bodies():
				if "Enemy" in b.name:
					boost = false
					break
			$Timer.start(1)
