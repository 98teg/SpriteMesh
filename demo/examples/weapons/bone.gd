extends SpriteMeshExample


func init_properties() -> void:
	name = "Bone"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 7, 0, 12, 24))
	set_axis(Vector3.AXIS_Y)
