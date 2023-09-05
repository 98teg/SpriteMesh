extends SpriteMeshExample


func init_properties() -> void:
	name = "Cavegirl 2"

	set_texture("Actor/Characters/Cavegirl2/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 0, 16 * 4, 16 * 4))
	set_hframes(4)
	set_vframes(4)
