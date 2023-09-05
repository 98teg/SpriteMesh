extends SpriteMeshExample


func init_properties() -> void:
	name = "Big Sword"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 6, 0, 12, 24))
	set_pixel_size(0.05)
