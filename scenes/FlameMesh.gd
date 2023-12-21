extends Node3D

signal the_beacons_are_lit

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_laser_pointer_ignite(name):
	if name == self and not self.is_visible_in_tree():
		self.show()
		the_beacons_are_lit.emit()
