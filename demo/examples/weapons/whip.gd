extends SpriteMeshExample


func init_properties() -> void:
	name = "Whip"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 3, 0, 12, 24))
	set_flip_v(true)
