extends Node3D

var casting_spell := "fizzle"
var saved_target
var left_controller := false

signal ignite
signal time_change
signal ice_bridge
signal ice_block
signal electric

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node_controller
	
	if left_controller:
		node_controller = %LeftController
	else:
		node_controller = %RightController
	
	self.global_position = node_controller.global_position
	self.global_rotation = node_controller.global_rotation

	var start_point = node_controller.global_position
	var end_point = node_controller.global_transform * Vector3(0, 0, -100)

	var query = PhysicsRayQueryParameters3D.create(start_point, end_point)
	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if !result.is_empty():
		if not self.visible:
			self.show()
		
		var collision_distance = result["position"].distance_to(start_point)
		self.scale.z = collision_distance
		self.position = result["position"].lerp(start_point, 0.5)
		
		var menus = get_tree().get_nodes_in_group("spatial_menus")
		for menu in menus:
			if result["collider_id"] == menu.get_instance_id():
				var menu_shape = menu.find_child("CollisionShape3D") as CollisionShape3D
				var box = menu_shape.shape as BoxShape3D

				var local_collision = menu.global_transform.inverse() * result["position"]
				var normalized_coords = Vector2(local_collision.x / box.size.x + 0.5, local_collision.z / box.size.z + 0.5)
				if normalized_coords.x >= .5:
					normalized_coords.x = (normalized_coords.x - .5) * 2
					var viewport = menu.get_parent().find_child("RightPageViewport") as SubViewport
					var viewport_coords = Vector2(viewport.size.x * normalized_coords.x, viewport.size.y * normalized_coords.y)
					
					var event = InputEventMouseMotion.new()
					event.position = viewport_coords
					event.global_position = viewport_coords
					viewport.push_input(event)
	else:
		self.hide()
		
func fizzle():
	self.casting_spell = "fizzle"
	self.saved_target = null
	$"../XRUser/XROrigin3D/RightController/RightHand".hand_material_override.albedo_color = Color(0, 0, 0)

func _on_casting_fire():
	$"../XRUser/XROrigin3D/RightController/RightHand".hand_material_override.albedo_color = Color(207.0/255.0, 25.0/255.0, 32.0/255.0)
	casting_spell = "fire"

func _on_casting_ice():
	$"../XRUser/XROrigin3D/RightController/RightHand".hand_material_override.albedo_color = Color(165.0/255.0, 242.0/255.0, 243.0/255.0)
	casting_spell = "ice"

func _on_casting_lightning():
	$"../XRUser/XROrigin3D/RightController/RightHand".hand_material_override.albedo_color = Color(120.0/255.0, 37.0/255.0, 164.0/255.0)
	casting_spell = "lightning"

func _on_casting_time_stop():
	$"../XRUser/XROrigin3D/RightController/RightHand".hand_material_override.albedo_color = Color(242.0/255.0, 209.0/255.0, 107.0/255.0)
	casting_spell = "time stop"


func _on_right_controller_button_pressed(name):
	if name != "trigger_click":
		return
	if casting_spell == "fizzle":
		return

	elif casting_spell == "time stop":
		time_change.emit()
		self.fizzle()
		
	var node_controller
	
	if left_controller:
		node_controller = %LeftController
	else:
		node_controller = %RightController
		
	var start_point = node_controller.global_position
	var end_point = node_controller.global_transform * Vector3(0, 0, -100)

	var query = PhysicsRayQueryParameters3D.create(start_point, end_point)
	query.collide_with_areas = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result.is_empty():
		return
	
	if casting_spell == "fire":
		if result["collider"] == $"../Hedge Gate/Gate/brazier1" or result["collider"] == $"../Hedge Gate/Gate/brazier2":
			ignite.emit(result["collider"].find_child("FlameMesh"))
		self.fizzle()
	
	elif casting_spell == "ice":
		if result["collider"] is StaticBody3D:
			if saved_target == null:
				saved_target = result["position"]
				ice_block.emit(saved_target)
			else:
				ice_bridge.emit(saved_target, result["position"])
				saved_target = null
				self.fizzle()
				
	
	elif casting_spell == "lightning":
		if result["collider"] == $"../Castle Wall/Castle Gate/SM_Prop_Water_Tower_01/Area3D":
			electric.emit()
		self.fizzle()
	
	else:
		return
