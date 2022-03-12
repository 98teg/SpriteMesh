class_name SpriteMesh, "icons/sprite_mesh.png"
extends Resource

#####################
# Public properties #
#####################

export(Array, Mesh) var meshes := []
export(SpatialMaterial) var material = SpatialMaterial.new()
