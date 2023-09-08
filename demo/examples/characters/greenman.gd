extends SpriteMeshExample


func init_properties() -> void:
	name = "Greenman"

	set_texture("Actor/Characters/Greenman/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 5, 16 * 4, 16 * 2))
	set_hframes(4)
	set_vframes(2)
