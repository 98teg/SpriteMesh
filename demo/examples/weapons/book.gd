extends SpriteMeshExample


func init_properties() -> void:
	name = "Book"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 8, 0, 12, 24))
	set_depth(2)
