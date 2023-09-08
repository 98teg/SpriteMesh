extends SpriteMeshExample


func init_properties() -> void:
	name = "Egg Boy"

	set_texture("Actor/Characters/EggBoy/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 1, 16 * 0, 16 * 1, 16 * 4))
	set_hframes(1)
	set_vframes(4)
