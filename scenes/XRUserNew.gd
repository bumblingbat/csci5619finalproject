extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_reset():
	self.global_position = Vector3(0, 0, 0)
	%XROrigin3D.global_position = Vector3(0, 0, 0)
