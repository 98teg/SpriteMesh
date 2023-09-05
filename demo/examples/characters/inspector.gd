extends SpriteMeshExample


func init_properties() -> void:
	name = "Inspector"

	set_texture("Actor/Characters/Inspector/SpriteSheet")

	set_region_enabled(true)
	set_region_rect(Rect2i(16 * 2, 16 * 5, 16 * 2, 16 * 2))
	set_hframes(2)
	set_vframes(2)
