extends SpriteMeshExample


func init_properties() -> void:
	name = "Gold Knight"

	set_texture("Actor/Characters/GoldKnight/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 0, 16 * 4, 16 * 4, 16 * 3))
	set_hframes(4)
	set_vframes(3)
