extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale.z = 100
	self.position.z = -50

	var start_point = get_parent().global_position
	var end_point = get_parent().global_transform * Vector3(0, 0, -100)

	var query = PhysicsRayQueryParameters3D.create(start_point, end_point)
	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if !result.is_empty():
		var collision_distance = result["position"].distance_to(start_point)
		self.scale.z = collision_distance
		self.position.z = -collision_distance / 2
		
	else:
		self.scale.z = 100
		self.position.z = -50

