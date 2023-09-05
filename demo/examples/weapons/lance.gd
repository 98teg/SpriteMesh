extends SpriteMeshExample


func init_properties() -> void:
	name = "Lance"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 2, 0, 12, 24))
	set_double_sided(false)
