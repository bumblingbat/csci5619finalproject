extends SubViewport

var last_position = Vector2(0.0, 0.0)
var mouse_position = Vector2(0.0, 0.0)
var snap_radius = 10 # Radius where the pen snaps to the node and draws a line
var drawing = false # Variable tracking if the trigger on the controller is depressed
var current_node_index = null # Variable tracking the node that is currently being drawn fron. Is null or 0-11
var node_history = [] # Stack tracking the nodes previously visited. Drawing pushes a node to the front, and backtracking pops from the front

# format of line indices:
#     *  0  *
#   1   2  3  4
#  *  5  *  6  *
#   7   8  9  A
#     *  B  *
# Format of node indices
#     3     4
#            
#  1     0     2
#  
#     5     6
var current_pattern = 0b000000000000 # twelve bit bitstring

var line_mask_0 = 0b000000000001
var line_mask_1 = 0b000000000010
var line_mask_2 = 0b000000000100
var line_mask_3 = 0b000000001000
var line_mask_4 = 0b000000010000
var line_mask_5 = 0b000000100000
var line_mask_6 = 0b000001000000
var line_mask_7 = 0b000010000000
var line_mask_8 = 0b000100000000
var line_mask_9 = 0b001000000000
var line_mask_A = 0b010000000000
var line_mask_B = 0b100000000000

var mask_list = [line_mask_0, line_mask_1, line_mask_2, line_mask_3, line_mask_4, line_mask_5, line_mask_6, line_mask_7, line_mask_8, line_mask_9, line_mask_A, line_mask_B]

# all patterns assume right end of the bitstring is the 0th index

#     * --- *
#   /      /  \
#  * --- *     *
#   \         /
#     * --- *
var ice_pattern = 0b110010111011

#     *     *
#          /  \
#  * --- *     *
#   \   /     /
#     * --- *
var fire_pattern = 0b110110111000

#     *     *
#   /  \      \
#  *     * --- *
#   \          
#     *     *
var lightning_pattern = 0b000011010110

#     * --- *
#   /          
#  *     *     *
#   \   /  \   
#     * --- *
var water_pattern = 0b101110000011

#     * --- *
#   /      /  \
#  * --- *     *
#       /  \  /
#     *     *
var wind_pattern = 0b011100111011

#     *     *
#      \   /   
#  *     *     *
#   \         /
#     * --- *
var size_down_pattern = 0b110010001100

#     * --- *
#   /         \
#  *     *     *
#      /   \    
#     *     *
var size_up_pattern = 0b001100010011

#     *     *
#   /         \
#  *     *     *
#      /   \   
#     * --- *
var frog_pattern = 0b101100010010

#     * --- *
#      \   /   
#  * --- * --- *
#      /   \   
#     * --- *
var time_stop_pattern = 0b101101101101

signal ice
signal fire
signal lightning
signal water
signal wind
signal size_down
signal size_up
signal frog
signal time_stop

# 900 width 1200 height

# (x, y) pixel offset from top left corner as (0, 0)
# center, left, right, top left, top right, bottom left, bottom right
#    0  ,  1  ,   2  ,    3    ,     4    ,      5     ,      6
var node_positions = [Vector2(450, 600), Vector2(100, 600), Vector2(800, 600), Vector2(237, 297), Vector2(625, 297), Vector2(237, 903), Vector2(625, 903)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Exit if not drawing
	if !drawing:
		return
	# Update mouse position
	mouse_position = get_mouse_position()
	print(mouse_position)
	# Exit if no movement
	if last_position == mouse_position:
		return
	else:
		last_position.x = mouse_position.x
		last_position.y = mouse_position.y
		#TODO update the appearance of the cursor line
	# For each node:
	for i in len(node_positions):
		# Check for new node snap
		if (mouse_position.distance_to(node_positions[i]) < snap_radius) and (i != current_node_index):
			# Erase last line if backtracking
			if (not node_history.is_empty()) and (i == node_history[0]):
				current_pattern = mask_list[get_line_index(i, node_history[0])] ^ current_pattern
				current_node_index = node_history.pop_front()
				#TODO erase last line and update the cursor line to be originating from node with index i
				break

			# Draw new line if valid
			elif check_line_available(get_line_index(i, current_node_index)):
				#TODO draw line from i to last_node index and update the cursor line to be originating from node with index i
				node_history.push_front(current_node_index)
				current_node_index = i
				print("snapped to node", i)
				break




func reset_grid():
	current_node_index = null
	node_history = []
	current_pattern = 0b000000000000
	drawing = false
	# TODO: clear lines drawn and the cursor line
  
func evaluate_drawing() -> String:
	if current_pattern == ice_pattern:
		return "ice"
	elif current_pattern == fire_pattern:
		return "fire"
	elif current_pattern == lightning_pattern:
		return "lightning"
	elif current_pattern == water_pattern:
		return "water"
	elif current_pattern == wind_pattern:
		return "wind"
	elif current_pattern == size_up_pattern:
		return "size_up"
	elif current_pattern == size_down_pattern:
		return "size_down"
	elif current_pattern == frog_pattern:
		return "frog"
	elif current_pattern == time_stop_pattern:
		return "time_stop"
	else:
		return "nothing"

func cast(spell_name):
	if spell_name == "nothing":
		return
	elif spell_name == "ice":
		ice.emit()
	elif spell_name == "fire":
		fire.emit()
	elif spell_name == "lightning":
		lightning.emit()
	elif spell_name == "water":
		water.emit()
	elif spell_name == "wind":
		wind.emit()
	elif spell_name == "size_up":
		size_up.emit()
	elif spell_name == "size_down":
		size_down.emit()
	elif spell_name == "frog":
		frog.emit()
	elif spell_name == "time_stop":
		time_stop.emit()

# Returns the index of the line between two adjacent nodes, and null if they are not adjacent
func get_line_index(node1, node2):
	# Initial invalid check
	if node1 == node2 or node1 == null or node2 == null:
		return null 
		
	# From Center node
	if node1 == 0:
		# to Left node
		if node2 == 1:
			# Checks if line is undrawn and returns that
			return 5

		# to Right node
		elif node2 == 2:
			# Checks if line is undrawn and returns that
			return 6

		# to Top Left node
		elif node2 == 3:
			# Checks if line is undrawn and returns that
			return 2

		# to Top Right node
		elif node2 == 4:
			# Checks if line is undrawn and returns that
			return 3

		# to Bottom Left node
		elif node2 == 5:
			# Checks if line is undrawn and returns that
			return 8

		# to Bottom Right node
		elif node2 == 6:
			# Checks if line is undrawn and returns that
			return 9

		# Impossible due to check at start of function
		else:
			return null

	# From Left node
	elif node1 == 1:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 5

		# to Top Left node
		if node2 == 3:
			# Checks if line is undrawn and returns that
			return 1

		# to Bottom Left node
		elif node2 == 5:
			# Checks if line is undrawn and returns that
			return 7

		# to Non-adjacent node
		else:
			return null

	# From Right node
	elif node1 == 2:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 6

		# to Top Right node
		if node2 == 4:
			# Checks if line is undrawn and returns that
			return 4

		# to Bottom Right node
		elif node2 == 6:
			# Checks if line is undrawn and returns that
			return 10

		# to Non-adjacent node
		else:
			return null
	
	# From Top Left node
	elif node1 == 3:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 2

		# to Left node
		if node2 == 1:
			# Checks if line is undrawn and returns that
			return 1

		# to Top Right node
		elif node2 == 4:
			# Checks if line is undrawn and returns that
			return 0

		# to Non-adjacent node
		else: 
			return null
	
	# From Top Right node
	elif node1 == 4:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 3
		
		# to Right node
		if node2 == 2:
			# Checks if line is undrawn and returns that
			return 4

		# to Top Left node
		elif node2 == 3:
			# Checks if line is undrawn and returns that
			return 0

		# to Non-adjacent node
		else: 
			return null

	# From Bottom Left node
	elif node1 == 5:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 8

		# to Left node
		if node2 == 1:
			# Checks if line is undrawn and returns that
			return 7

		# to Bottom Right node
		elif node2 == 6:
			# Checks if line is undrawn and returns that
			return 11

		# to Non-adjacent node
		else:
			return null
	
	# From Bottom Right node
	elif node1 == 6:
		# to Center node
		if node2 == 0:
			# Checks if line is undrawn and returns that
			return 9
		
		# to Right node
		if node2 == 2:
			# Checks if line is undrawn and returns that
			return 10

		# to Bottom Left node
		elif node2 == 5:
			# Checks if line is undrawn and returns that
			return 11

		# to Non-adjacent node
		else:
			return null

	# Impossible
	else:
		return null

func check_line_available(line_index) -> bool:
	if line_index == null:
		return false
	return (mask_list[line_index] & current_pattern) == 0
  
# placeholder function for starting to draw, needs more logic
func _on_trigger_pressed(button):
	if button == "grip_click":
		var book_spell = $"../../../LeftSide/LeftPage/SpellListViewport/CanvasLayer".current_spell
		if book_spell == 0:
			fire.emit()
		elif book_spell == 1:
			ice.emit()
		elif book_spell == 2:
			lightning.emit()
		elif book_spell == 3:
			time_stop.emit()
	
	if button != "trigger_click":
		return
	last_position = get_mouse_position()

	for i in range(len(node_positions)):
		if node_positions[i].distance_to(last_position) < snap_radius:
			current_node_index = i
			drawing = true
			#TODO: draw cursor line
			return

# placeholder function for ending drawing session, needs more logic
func _on_trigger_released(button):
	if button != "trigger_click":
		return
	#cast(evaluate_drawing())
	reset_grid()

func _on_button_pressed():
	print("Button pressed")
