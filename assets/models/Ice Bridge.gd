extends Node3D

var default_scale := 1.75

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody3D.set_collision_layer_value(2, true)
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_laser_pointer_ice_bridge(position1 : Vector3, position2 : Vector3):
	self.position = ((position2 - position1) / 2) + position1
	self.position.y -= 0.08
	self.look_at(Vector3(position2.x, position2.y - 0.08, position2.z))
	self.scale.z = position1.distance_to(position2) / 1.75
	$StaticBody3D.set_collision_layer_value(1, true)
	self.show()


func _on_laser_pointer_ice_block(pos):
	self.position = pos
	self.position.y -= 0.08
	self.rotation = Vector3.UP
	self.scale = Vector3(1, 1, 1)
	self.show()

func _on_laser_pointer_bridge(position1, position2):
	print("test")
	self._on_laser_pointer_bridge(position1, position2)
	$StaticBody3D.set_collision_layer_value(1, false)
	self.show()
