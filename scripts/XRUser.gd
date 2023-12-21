#extends Node3D
extends RigidBody3D

@export var max_speed:= 2.5
@export var dead_zone := 0.2

@export var smooth_turn_speed:= 45.0
@export var smooth_turn_dead_zone := 0.2

@export var snap_turn_speed:= 45.0
@export var snap_turn_dead_zone := 0.9

var input_vector:= Vector2.ZERO

var hand_mode := 0 # var to hold whether view or hand directed 
var snap_mode := 0 # var to hold whether smooth or snap turn 
var timer := 0.0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# Forward translation
	if self.input_vector.y > self.dead_zone || self.input_vector.y < -self.dead_zone:
		var movement_vector = Vector3(0, 0, max_speed * -self.input_vector.y * delta)
		if hand_mode == 1: # hand directed 
			self.position += movement_vector.rotated(Vector3.UP, %RightController.global_rotation.y)
		else: # view directed 
			self.position += movement_vector.rotated(Vector3.UP, %XRCamera3D.global_rotation.y)

	if snap_mode == 1: # snap turn 
		if timer < 0:
			timer = 0
		if timer == 0: # cooldown between 
			if self.input_vector.x > self.snap_turn_dead_zone || self.input_vector.x < -self.snap_turn_dead_zone:
				
				# move to the position of the camera
				self.translate(%XRCamera3D.position)

				# rotate about the camera's position
				self.rotate(Vector3.UP, deg_to_rad(smooth_turn_speed) * -self.input_vector.x)

				# reverse the translation to move back to the original position
				self.translate(%XRCamera3D.position * -1)
				
				timer = 0.6
		else:
			timer -= delta
			
	else: # smooth turn
		if self.input_vector.x > self.smooth_turn_dead_zone || self.input_vector.x < -self.smooth_turn_dead_zone:

			# move to the position of the camera
			self.translate(%XRCamera3D.position)

			# rotate about the camera's position
			self.rotate(Vector3.UP, deg_to_rad(smooth_turn_speed) * -self.input_vector.x * delta)

			# reverse the translation to move back to the original position
			self.translate(%XRCamera3D.position * -1)
	

func reset(_body):	
	# go back to start
	self.position = (Vector3(0, 0, 0))
	self.rotation.y = PI

	
func process_input(input_name: String, input_value: Vector2):
	if input_name == "primary":
		input_vector = input_value


func _on_right_controller_button_pressed(button_name):
	if button_name == "ax_button": # ax_button switches btwn view and hand mode 
		if hand_mode == 1:
				hand_mode = 0
		else:
			hand_mode = 1
	if button_name == "by_button": # by_button switches btwn smooth and snap turn
		if snap_mode == 1:
			snap_mode = 0
		else:
			snap_mode = 1


func _on_left_controller_button_pressed(button_name):
	if button_name == "ax_button": # ax_button switches btwn view and hand mode 
		if hand_mode == 1:
				hand_mode = 0
		else:
			hand_mode = 1
	if button_name == "by_button": # by_button switches btwn smooth and snap turn
		if snap_mode == 1:
			snap_mode = 0
		else:
			snap_mode = 1
