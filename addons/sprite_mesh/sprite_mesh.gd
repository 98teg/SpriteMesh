extends Resource
class_name SpriteMesh, "icons/sprite_mesh.png"

#####################
# Public properties #
#####################

export(Array, Mesh) var meshes := []
export(SpatialMaterial) var material = SpatialMaterial.new()
