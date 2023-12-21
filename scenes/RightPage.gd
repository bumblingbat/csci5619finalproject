extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	subViewport = selg.getchild("SubViewport")
	var viewportTexture = subViewport.GetTexture()

	MeshInstance3D meshInstance = GetNode<MeshInstance3D>("Mesh")

	StandardMaterial3D mat = new()
	{
		AlbedoTexture = viewportTexture
	};

	meshInstance.SetSurfaceOverrideMaterial(0, mat)

	RenderingServer.FramePostDraw -= OnFramePostDraw


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
