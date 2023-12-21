extends Node3D

signal reset

var time_stopped := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_stopped:
		return
	var movement_vector = Vector3(0, 0, 5 * delta)
	
	if self.position.x > 21 || self.position.x < -21: 
		self.rotate(Vector3.UP, deg_to_rad(180))
		if self.position.x > 21:
			self.position.x = 21
		else:
			self.position.x = -21
	
	self.position += movement_vector.rotated(Vector3.UP, self.rotation.y)

func _on_cowboy_area_entered(area):
	if area == $"../../XRUser/XROrigin3D/PlayerArea":
		reset.emit()

func _on_time_change():
	time_stopped = not time_stopped
