extends Node3D

var moving := false
var speed := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		for i in self.get_children():
			if i == $door_right:
				$door_right.position.x -= delta * speed
			elif i == $door_left:
				$door_left.position.x += delta * speed
			if abs(i.position.x) > 3:
				moving = false


func _on_laser_pointer_electric():
	moving = true
