extends SpriteMeshExample


func init_properties() -> void:
	name = "Stick"

	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 4, 0, 12, 24))
	set_offset(Vector2(1, 2), 3)
