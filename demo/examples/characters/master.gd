extends SpriteMeshExample


func init_properties() -> void:
	name = "Master"

	set_texture("Actor/Characters/Master/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 0, 16 * 4, 16 * 4))
	set_hframes(4)
	set_vframes(4)

	set_offset(Vector2(1, 2), 3)
