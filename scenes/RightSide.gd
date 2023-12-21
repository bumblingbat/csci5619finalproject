extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():

	var meshInstance: MeshInstance3D = self.get_child(0)
	var subViewport: SubViewport = meshInstance.get_child(0)
	var viewportTexture: ViewportTexture = subViewport.get_texture()

	var mat: StandardMaterial3D
	
	mat.albedo_texture = viewportTexture

	meshInstance.material_override = mat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
