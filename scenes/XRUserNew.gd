extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.position.y < -0.5:
		print("below")
		self.position = Vector3(0, 0, 0)
		self.rotation.y = PI

func _on_reset():
	print("reseting")
	self.position = Vector3(0, 0, 0)
