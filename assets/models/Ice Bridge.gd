extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_laser_pointer_ice_bridge(position1, position2):
	self.position = position1.lerp(position2, 0.5)
	self.look_at(position2)
	self.scale.z = position1.distance_to(position2) / 1.75
	self.show()


func _on_laser_pointer_ice_block(position1):
	self.position = position1
	self.rotation = Vector3.UP
	self.scale = Vector3(1, 1, 1)
	self.show()
