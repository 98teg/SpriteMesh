extends SpriteMeshExample


func init_properties() -> void:
	name = "Egg Girl"

	set_texture("Actor/Characters/EggGirl/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 2, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)
