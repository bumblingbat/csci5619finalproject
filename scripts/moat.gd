extends Area3D

signal reset

@onready var globals = get_node("/root/Globals")

func _on_area_entered(area):
	if area.name == globals.XRUser:
		reset.emit()
