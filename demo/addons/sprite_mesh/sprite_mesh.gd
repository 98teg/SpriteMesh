@icon("icons/sprite_mesh.svg")
class_name SpriteMesh
extends Resource


@export var meshes: Array[Mesh] = []: set = set_meshes
@export var material: StandardMaterial3D = StandardMaterial3D.new(): set = set_material


func set_meshes(new_meshes: Array[Mesh]) -> void:
	if meshes != new_meshes:
		meshes = new_meshes
		emit_changed()


func set_material(new_material: StandardMaterial3D) -> void:
	if material != new_material:
		material = new_material
		emit_changed()
