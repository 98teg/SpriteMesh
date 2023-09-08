extends SpriteMeshExample


func init_properties() -> void:
	name = "Club"
	
	set_texture("Items/Weapons")

	set_region_enabled(true)
	set_region_rect(Rect2i(12 * 9, 0, 12, 24))
