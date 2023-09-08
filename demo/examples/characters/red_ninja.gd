extends SpriteMeshExample


func init_properties() -> void:
	name = "Red Ninja"

	set_texture("Actor/Characters/RedNinja/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 4, 16 * 4, 16 * 3))
	set_hframes(4)
	set_vframes(3)

	set_pixel_size(0.05)
	set_axis(Vector3.AXIS_Y)
