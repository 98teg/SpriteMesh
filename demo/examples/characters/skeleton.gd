extends SpriteMeshExample


func init_properties() -> void:
	name = "Skeleton"

	set_texture("Actor/Characters/Skeleton/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 2, 16 * 5, 16 * 2, 16 * 2))
	set_hframes(2)
	set_vframes(2)

	set_flip_v(true)
	set_flip_h(true)
