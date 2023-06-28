@icon("icons/sprite_mesh.png")
class_name SpriteMesh
extends Resource

#####################
# Public properties #
#####################

@export var meshes: Array[Mesh] = []
@export var material := StandardMaterial3D.new()
