extends SpriteMeshExample


func init_properties() -> void:
	name = "Eskimo"

	set_texture("Actor/Characters/Eskimo/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 4, 16 * 4, 16 * 1))
	set_hframes(4)
	set_vframes(1)
