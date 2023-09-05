extends SpriteMeshExample


func init_properties() -> void:
	name = "Sushi 2"

	set_texture("Items/Food/Sushi2")

	set_depth(2.5)
	set_double_sided(false)
	set_offset(Vector2(-2, 1), 3)
