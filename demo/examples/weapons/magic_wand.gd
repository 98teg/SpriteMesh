extends SpriteMeshExample


func init_properties() -> void:
	name = "Magic Wand"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 1, 0, 12, 24))
	set_centered(false)
