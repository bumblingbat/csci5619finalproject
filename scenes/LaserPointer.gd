extends Node3D

var casting_spell := "fizzle"
var saved_target

signal ignite
signal time_change
signal ice_bridge

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
		
func fizzle():
	self.casting_spell = "fizzle"
	self.saved_target = null
	$"../RightHand".hand_material_override.albedo_color = Color(0, 0, 0)

func _on_casting_fire():
	$"../RightHand".hand_material_override.albedo_color = Color(207.0/255.0, 25.0/255.0, 32.0/255.0)
	casting_spell = "fire"

func _on_casting_ice():
	$"../RightHand".hand_material_override.albedo_color = Color(165.0/255.0, 242.0/255.0, 243.0/255.0)
	casting_spell = "ice"

func _on_casting_lightning():
	$"../RightHand".hand_material_override.albedo_color = Color(120.0/255.0, 37.0/255.0, 164.0/255.0)
	casting_spell = "lightning"

func _on_casting_time_stop():
	$"../RightHand".hand_material_override.albedo_color = Color(242.0/255.0, 209.0/255.0, 107.0/255.0)
	casting_spell = "time stop"


func _on_right_controller_button_pressed(name):
	if name != "trigger_click":
		return
	if casting_spell == "fizzle":
		return

	elif casting_spell == "time stop":
		time_change.emit()
		self.fizzle()
		
	var start_point = get_parent().global_position
	var end_point = get_parent().global_transform * Vector3(0, 0, -100)

	var query = PhysicsRayQueryParameters3D.create(start_point, end_point)
	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		return
	
	if casting_spell == "fire":
		if result["collider"] == $"../../../../Hedge Gate/Gate/brazier1" or result["collider"] == $"../../../../Hedge Gate/Gate/brazier2":
			ignite.emit(result["collider"].find_child("FlameMesh"))
		self.fizzle()
	
	elif casting_spell == "ice":
		if result["collider"] is StaticBody3D:
			if saved_target == null:
				saved_target = result["position"]
			else:
				ice_bridge.emit(saved_target, result["position"])
				saved_target = null
				self.fizzle()
				
	
	elif casting_spell == "lightning":
		if result["collider"] is StaticBody3D:
			pass
		self.fizzle()
	
	else:
		return
