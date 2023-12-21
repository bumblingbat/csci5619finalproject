extends Node3D

var active_braziers := 0
var moving := false
var speed := 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		self.get_parent().position.y -= delta * speed
		if self.get_parent().position.y < -3:
			moving = false


func _on_the_beacons_are_lit():
	active_braziers += 1
	if active_braziers == 2:
		moving = true
