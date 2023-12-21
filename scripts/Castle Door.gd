extends Node3D

var moving := false
var speed := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		$door_right.position.x -= speed * delta
		$door_left.position.x += speed * delta
		if $door_left.position.x > 3:
			moving = false


func _on_laser_pointer_electric():
	moving = true
