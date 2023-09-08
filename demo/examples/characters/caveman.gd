extends SpriteMeshExample


func init_properties() -> void:
	name = "Caveman"

	set_texture("Actor/Characters/Caveman/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 1, 16 * 0, 16 * 3, 16 * 4))
	set_hframes(3)
	set_vframes(4)
