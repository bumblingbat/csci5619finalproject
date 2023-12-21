extends Node3D

var default_scale := 1.75

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_laser_pointer_ice_bridge(position1 : Vector3, position2 : Vector3):
	self.position = ((position2 - position1) / 2) + position1
	self.position.y -= 0.08
	self.look_at(Vector3(position2.x, position2.y - 0.08, position2.z))
	self.scale.z = position1.distance_to(position2) / 1.75
	self.show()
