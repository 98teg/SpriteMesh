extends SpriteMeshExample


func init_properties() -> void:
	name = "Gray Ninja"

	set_texture("Actor/Characters/GrayNinja/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 5, 16 * 4, 16 * 1))
	set_hframes(4)
	set_vframes(1)
