extends SpriteMeshExample


func init_properties() -> void:
	name = "Blue Samurai"

	set_texture("Actor/Characters/BlueSamurai/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)
