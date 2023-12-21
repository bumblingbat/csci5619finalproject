extends Area3D

signal reset

func _on_area_entered(area):
	#if area == $"../../XRUser/XROrigin3D/PlayerArea":
	if area == %PlayerArea:
		reset.emit()
