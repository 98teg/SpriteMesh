extends SpriteMeshExample


func init_properties() -> void:
	name = "Old Man 3"

	set_texture("Actor/Characters/OldMan3/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 4, 16 * 4, 16 * 1))
	set_hframes(4)
	set_vframes(1)

	set_depth(2.5)
	set_double_sided(false)
	set_offset(Vector2(-2, 1), 3)
