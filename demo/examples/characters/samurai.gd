extends SpriteMeshExample


func init_properties() -> void:
	name = "Samurai"

	set_texture("Actor/Characters/Samurai/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 5, 16 * 4, 16 * 2))
	set_hframes(4)
	set_vframes(2)

	set_depth(2.5)
	set_double_sided(false)
