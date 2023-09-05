extends SpriteMeshExample


func init_properties() -> void:
	name = "Old Woman"

	set_texture("Actor/Characters/OldWoman/SpriteSheet")

	set_hframes(4)
	set_vframes(2)

	set_pixel_size(0.04)
	set_centered(false)
	set_axis(Vector3.AXIS_Y)
