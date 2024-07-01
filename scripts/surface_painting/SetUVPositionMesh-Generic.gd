extends MeshInstance3D

@export var UVPosition: Node

func _ready():
	UVPosition.set_mesh(self)
