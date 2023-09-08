extends SpriteMeshExample


func init_properties() -> void:
	name = "Sword"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 5, 0, 12, 24))
	set_flip_h(true)
