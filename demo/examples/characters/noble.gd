extends SpriteMeshExample


func init_properties() -> void:
	name = "Noble"

	set_texture("Actor/Characters/Noble/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 3, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)

	set_axis(Vector3.AXIS_Y)
