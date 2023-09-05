extends SpriteMeshExample


func init_properties() -> void:
	name = "Old Man"

	set_texture("Actor/Characters/OldMan/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 1, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)

	set_flip_h(true)
	set_flip_v(true)
	set_axis(Vector3.AXIS_X)
