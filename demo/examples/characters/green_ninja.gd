extends SpriteMeshExample


func init_properties() -> void:
	name = "Green Ninja"

	set_texture("Actor/Characters/GreenNinja/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 6, 16 * 4, 16 * 1))
	set_hframes(4)
	set_vframes(1)
