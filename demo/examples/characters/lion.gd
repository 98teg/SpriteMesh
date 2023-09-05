extends SpriteMeshExample


func init_properties() -> void:
	name = "Lion"

	set_texture("Actor/Characters/Lion/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)

	set_pixel_size(0.05)
