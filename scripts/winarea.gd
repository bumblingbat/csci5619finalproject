extends Node3D

signal win

func _on_area_entered(area):
	if area == %PlayerArea:
		win.emit()
