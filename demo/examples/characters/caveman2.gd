extends SpriteMeshExample


func init_properties() -> void:
	name = "Caveman 2"

	set_texture("Actor/Characters/Caveman2/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 2, 16 * 0, 16 * 2, 16 * 4))
	set_hframes(2)
	set_vframes(4)
