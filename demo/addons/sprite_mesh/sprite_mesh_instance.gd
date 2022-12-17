@tool
class_name SpriteMeshInstance
extends MeshInstance3D
@icon("icons/sprite_mesh_instance.svg")


const Quad = preload("./scripts/quad.gd")
const Frame = preload("./scripts/frame.gd")
const GreedyAlgorithm = preload("./scripts/greedy_algorithm.gd")

@export var texture: Texture2D: set = set_texture

@export_group("Mesh Properties", "mesh_")
@export_range(0, 128, 0.01, "suffix:px") var mesh_depth := 1.0: set = set_mesh_depth
@export_range(0, 128, 0.01, "suffix:m") var mesh_pixel_size := 0.01: set = set_mesh_pixel_size
@export var mesh_double_sided := true: set = set_mesh_double_sided

@export_group("Animation", "animation_")
@export_range(1, 16384) var animation_hframes := 1: set = set_animation_hframes
@export_range(1, 16384) var animation_vframes := 1: set = set_animation_vframes
@export_range(0, 16383) var animation_frame := 0: set = set_animation_frame
@export var animation_frame_coords := Vector2i(0, 0): set = set_animation_frame_coords

@export_group("Region", "region_")
@export var region_enabled := false: set = set_region_enabled
@export var region_rect := Rect2i(0, 0, 1, 1): set = set_region_rect

@export_group("Position", "position_")
@export var position_centered := true: set = set_position_centered
@export var position_offset := Vector3.ZERO: set = set_position_offset
@export var position_flip_h := false: set = set_position_flip_h
@export var position_flip_v := false: set = set_position_flip_v
@export_enum("X-Axis", "Y-Axis", "Z-Axis") var position_axis := Vector3.AXIS_Z:
	set = set_position_axis

@export_group("Generation Parameters", "generation_")
@export_range(0, 1) var generation_alpha_threshold := 0.0: set = set_generation_alpha_threshold
@export_range(0, 1) var generation_uv_correction := 0.0: set = set_generation_uv_correction

@export_group("Generated SpriteMesh", "generated_")
@export var generated_sprite_mesh := SpriteMesh.new(): set = set_generated_sprite_mesh

var _pending_update := false
var _seconds_left := 0.0


func _ready():
	_pending_update = false


func _process(delta: float):
	if Engine.is_editor_hint() and _pending_update:
		if _seconds_left <= 0:
			_pending_update = false
			generated_sprite_mesh = _generate_sprite_mesh()
		else:
			_seconds_left -= delta


func update_sprite_mesh() -> void:
	if _pending_update:
		_pending_update = false
		generated_sprite_mesh = _generate_sprite_mesh()


func get_mesh_with_index(index: int) -> Mesh:
	var size := generated_sprite_mesh.meshes.size()
	if(size == 0):
		return Mesh.new()
	return generated_sprite_mesh.meshes[index % size]


func _request_update() -> void:
	_pending_update = true

	if Engine.is_editor_hint():
		_seconds_left = 1


func _generate_sprite_mesh() -> SpriteMesh:
	var sprite_mesh := SpriteMesh.new()
	sprite_mesh.connect("changed", _apply_generated_sprite_mesh)

	if texture == null:
		return sprite_mesh

	sprite_mesh.meshes = _generate_meshes()
	sprite_mesh.material = _generate_material()

	return sprite_mesh


func _generate_meshes() -> Array[Mesh]:
	var meshes: Array[Mesh] = []

	var st := SurfaceTool.new()
	var algorithm := GreedyAlgorithm.new()

	algorithm.show_side_quads = mesh_depth != 0
	algorithm.show_back_quads = mesh_double_sided
	algorithm.alpha_threshold = generation_alpha_threshold
	algorithm.uv_correction = generation_uv_correction

	for frame in _get_frames():
		algorithm.image = frame.image

		var quads = algorithm.generate_quads()

		st.begin(Mesh.PRIMITIVE_TRIANGLES)

		for quad in quads:
			_transform_quad(quad, frame)
			quad.render(st)

		st.generate_normals()
		st.generate_tangents()

		st.index()

		meshes.append(st.commit())

		st.clear()

	return meshes


func _generate_material() -> StandardMaterial3D:
	var material := StandardMaterial3D.new()

	material.set_texture(StandardMaterial3D.TEXTURE_ALBEDO, texture)
	material.texture_filter = StandardMaterial3D.TEXTURE_FILTER_NEAREST

	return material


func _transform_quad(quad: Quad, frame: Frame) -> void:
	if position_centered:
		quad.translate(Vector3(-frame.get_width() / 2.0, -frame.get_height() / 2.0, 0.5))

	quad.scale(Vector3(mesh_pixel_size, mesh_pixel_size, mesh_pixel_size * mesh_depth))

	quad.translate(position_offset)

	match position_axis:
		Vector3.AXIS_X:
			quad.rotate(Vector3.UP, deg_to_rad(90))
		Vector3.AXIS_Y:
			quad.rotate(Vector3.LEFT, deg_to_rad(90))

	quad.scale_uvs(Vector2(frame.get_size()) / texture.get_size())
	quad.translate_uvs(Vector2(frame.get_position()) / texture.get_size())

	if position_flip_h:
		quad.flip_uvs_h()

	if position_flip_v:
		quad.flip_uvs_v()


func _apply_generated_sprite_mesh() -> void:
	mesh = get_mesh_with_index(animation_frame)
	if get_surface_override_material_count() != 0:
		set_surface_override_material(0, generated_sprite_mesh.material)


func _clear_sprite_mesh() -> void:
	if get_surface_override_material_count() != 0:
		set_surface_override_material(0, null)

	mesh = null


func _get_frames() -> Array:
	var image := texture.get_image()
	if region_enabled:
		image = image.get_region(region_rect)
	image.decompress()

	var frames_offset := region_rect.position if region_enabled else Vector2i.ZERO
	var frame_size := Vector2i(
		image.get_width() / animation_hframes,
		image.get_height() / animation_vframes
	)

	var frames: Array = []

	for i in range(animation_vframes):
		for j in range(animation_hframes):
			var frame := Frame.new()
			var frame_position := Vector2i(j * frame_size.x, i * frame_size.y)
			
			frame.image = image.get_region(Rect2i(frame_position, frame_size))
			frame.position = frames_offset + frame_position

			if position_flip_h:
				frame.flip_h()

			if position_flip_v:
				frame.flip_v()

			frames.append(frame)

	return frames


func set_texture(new_texture: Texture2D) -> void:
	texture = new_texture

	_request_update()


func set_mesh_depth(new_mesh_depth: float) -> void:
	mesh_depth = clampf(new_mesh_depth, 0, 128)

	_request_update()


func set_mesh_pixel_size(new_mesh_pixel_size: float) -> void:
	mesh_pixel_size = clampf(new_mesh_pixel_size, 0, 128)

	_request_update()


func set_mesh_double_sided(new_mesh_double_sided: bool) -> void:
	mesh_double_sided = new_mesh_double_sided

	_request_update()


func set_animation_hframes(new_animation_hframes: int) -> void:
	animation_hframes = clampi(new_animation_hframes, 1, 16384)

	_request_update()


func set_animation_vframes(new_animation_vframes: int) -> void:
	animation_vframes = clampi(new_animation_vframes, 1, 16384)

	_request_update()


func set_animation_frame(new_animation_frame: int) -> void:
	if animation_frame == new_animation_frame:
		return

	animation_frame = absi(new_animation_frame) % (animation_hframes * animation_vframes)

	if generated_sprite_mesh.meshes.size() != 0:
		mesh = get_mesh_with_index(animation_frame)

	animation_frame_coords = Vector2i(
		animation_frame % animation_hframes,
		animation_frame / animation_hframes,
	)


func set_animation_frame_coords(new_animation_frame_coords: Vector2i) -> void:
	if animation_frame_coords == new_animation_frame_coords:
		return

	animation_frame_coords = Vector2i(
		absi(new_animation_frame_coords.x) % animation_hframes,
		absi(new_animation_frame_coords.y) % animation_vframes,
	)

	animation_frame = animation_frame_coords.x + animation_frame_coords.y * animation_hframes


func set_position_centered(new_position_centered: bool) -> void:
	position_centered = new_position_centered

	_request_update()


func set_position_offset(new_position_offset: Vector3) -> void:
	position_offset = new_position_offset

	_request_update()


func set_position_flip_h(new_position_flip_h: bool) -> void:
	position_flip_h = new_position_flip_h

	_request_update()


func set_position_flip_v(new_position_flip_v: bool) -> void:
	position_flip_v = new_position_flip_v

	_request_update()


func set_position_axis(new_position_axis: int) -> void:
	position_axis = clampi(new_position_axis, 0, 2)

	_request_update()


func set_region_enabled(new_region_enabled: bool) -> void:
	region_enabled = new_region_enabled

	_request_update()


func set_region_rect(new_region_rect: Rect2) -> void:
	if texture == null:
		region_rect = Rect2(0, 0, 1, 1)
		return

	region_rect.position.x = clampi(new_region_rect.position.x, 0, texture.get_width() - 1)
	region_rect.position.y = clampi(new_region_rect.position.y, 0, texture.get_height() - 1)
	region_rect.size.x = clampi(
		new_region_rect.size.x, 1, texture.get_width() - region_rect.position.x
	)
	region_rect.size.y = clampi(
		new_region_rect.size.y, 1, texture.get_height() - region_rect.position.y
	)

	_request_update()


func set_generation_alpha_threshold(new_generation_alpha_threshold: float) -> void:
	generation_alpha_threshold = clampf(new_generation_alpha_threshold, 0, 1)

	_request_update()


func set_generation_uv_correction(new_generation_uv_correction: float) -> void:
	generation_uv_correction = clampf(new_generation_uv_correction, 0, 30)

	_request_update()


func set_generated_sprite_mesh(new_generated_sprite_mesh: SpriteMesh) -> void:
	generated_sprite_mesh = new_generated_sprite_mesh
	generated_sprite_mesh.connect("changed", _apply_generated_sprite_mesh)

	if generated_sprite_mesh == null:
		_clear_sprite_mesh()
	else:
		_apply_generated_sprite_mesh()


func get_texture():
	return texture


func get_mesh_depth() -> float:
	return mesh_depth


func get_mesh_pixel_size() -> float:
	return mesh_pixel_size


func is_mesh_double_sided() -> bool:
	return mesh_double_sided


func get_animation_hframes() -> int:
	return animation_hframes


func get_animation_vframes() -> int:
	return animation_vframes


func get_animation_frame() -> int:
	return animation_frame


func get_animation_frame_coords() -> Vector2i:
	return animation_frame_coords


func is_position_centered() -> bool:
	return position_centered


func get_position_offset() -> Vector3:
	return position_offset


func is_position_flip_h() -> bool:
	return position_flip_h


func is_position_flip_v() -> bool:
	return position_flip_v


func get_position_axis() -> int:
	return position_axis


func is_region_enabled() -> bool:
	return region_enabled


func get_region_rect() -> Rect2i:
	return region_rect


func get_generation_alpha_threshold() -> float:
	return generation_alpha_threshold


func get_generation_uv_correction() -> float:
	return generation_uv_correction


func get_generated_sprite_mesh() -> SpriteMesh:
	return generated_sprite_mesh
