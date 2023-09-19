class_name SpriteMeshExample
extends RefCounted


const TEXTURE_PATH := "res://assets/NinjaAdventure/%s.png"

var name := ""
var sprite_3d := Sprite3D.new()
var sprite_mesh_instance := SpriteMeshInstance.new()
var changed_properties: Array[String] = []


func _init() -> void:
	sprite_3d.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS

	init_properties()

	sprite_mesh_instance.update_sprite_mesh()


func init_properties() -> void:
	pass


func set_texture(texture_name: String) -> void:
	var texture: Texture2D = load(TEXTURE_PATH % texture_name)

	sprite_3d.texture = texture
	sprite_mesh_instance.texture = texture


func set_depth(depth: float) -> void:
	sprite_mesh_instance.depth = depth

	changed_properties.append("Depth: %0.2f" % depth)


func set_pixel_size(pixel_size: float) -> void:
	sprite_3d.pixel_size = pixel_size
	sprite_mesh_instance.pixel_size = pixel_size

	changed_properties.append("Pixel size: %0.2f" % pixel_size)


func set_double_sided(double_sided: bool) -> void:
	sprite_3d.double_sided = double_sided
	sprite_mesh_instance.double_sided = double_sided

	changed_properties.append("Double sided: %s" % double_sided)


func set_centered(centered: bool) -> void:
	sprite_3d.centered = centered
	sprite_mesh_instance.centered = centered

	changed_properties.append("Centered: %s" % centered)


func set_offset(offset: Vector2, offset_z: float) -> void:
	sprite_3d.offset = offset
	sprite_mesh_instance.offset = Vector3(offset.x, offset.y, offset_z)

	changed_properties.append("Offset: x=%0.2f, y=%0.2f, z=%0.2f" % [offset.x, offset.y, offset_z])


func set_flip_h(flip_h: bool) -> void:
	sprite_3d.flip_h = flip_h
	sprite_mesh_instance.flip_h = flip_h

	changed_properties.append("Flip H: %s" % flip_h)


func set_flip_v(flip_v: bool) -> void:
	sprite_3d.flip_v = flip_v
	sprite_mesh_instance.flip_v = flip_v

	changed_properties.append("Flip V: %s" % flip_v)


func set_axis(axis: int) -> void:
	sprite_3d.axis = axis
	sprite_mesh_instance.axis = axis

	match axis:
		Vector3.AXIS_X:
			changed_properties.append("Axis X")
		Vector3.AXIS_Y:
			changed_properties.append("Axis Y")
		Vector3.AXIS_Z:
			changed_properties.append("Axis Z")


func set_hframes(hframes: int) -> void:
	sprite_3d.hframes = hframes
	sprite_mesh_instance.hframes = hframes

	changed_properties.append("H Frames: %d" % hframes)


func set_vframes(vframes: int) -> void:
	sprite_3d.vframes = vframes
	sprite_mesh_instance.vframes = vframes

	changed_properties.append("V Frames: %d" % vframes)


func set_frame(frame: int) -> void:
	sprite_3d.frame = frame
	sprite_mesh_instance.frame = frame

	changed_properties.append("Frame: %d" % frame)


func set_frame_coords(frame_coords: Vector2i) -> void:
	sprite_3d.frame_coords = frame_coords
	sprite_mesh_instance.frame_coords = frame_coords

	changed_properties.append("Frame coords: x=%d, y=%d" % [frame_coords.x, frame_coords.y])


func set_region_enabled(region_enabled: bool) -> void:
	sprite_3d.region_enabled = region_enabled
	sprite_mesh_instance.region_enabled = region_enabled

	changed_properties.append("Region enabled: %s" % region_enabled)


func set_region_rect(region_rect: Rect2i) -> void:
	sprite_3d.region_rect = region_rect
	sprite_mesh_instance.region_rect = region_rect

	changed_properties.append("Frame coords: x=%d, y=%d, w=%d, h=%d" % [
		region_rect.position.x,
		region_rect.position.y,
		region_rect.size.x,
		region_rect.size.y,
	])


func set_alpha_threshold(alpha_threshold: float) -> void:
	sprite_mesh_instance.alpha_threshold = alpha_threshold

	changed_properties.append("Alpha threshold: %0.2f" % alpha_threshold)


func set_uv_correction(uv_correction: float) -> void:
	sprite_mesh_instance.uv_correction = uv_correction

	changed_properties.append("UV Correction: %0.2f" % uv_correction)


func property_differences() -> Array[String]:
	var differences: Array[String] = []
	var msg := 'Error: "%s" does not have the same value.'

	if sprite_3d.get_pixel_size() != sprite_mesh_instance.get_pixel_size():
		differences.push_back(msg % "pixel_size")

	if sprite_3d.get_double_sided() != sprite_mesh_instance.get_double_sided():
		differences.push_back(msg % "double_sided")

	if sprite_3d.get_centered() != sprite_mesh_instance.get_centered():
		differences.push_back(msg % "centered")

	var offset := sprite_mesh_instance.get_offset()
	if sprite_3d.get_offset() != Vector2(offset.x, offset.y):
		differences.push_back(msg % "offset")

	if sprite_3d.get_flip_h() != sprite_mesh_instance.get_flip_h():
		differences.push_back(msg % "flip_h")

	if sprite_3d.get_flip_v() != sprite_mesh_instance.get_flip_v():
		differences.push_back(msg % "flip_v")

	if sprite_3d.get_axis() != sprite_mesh_instance.get_axis():
		differences.push_back(msg % "axis")

	if sprite_3d.get_hframes() != sprite_mesh_instance.get_hframes():
		differences.push_back(msg % "hframes")

	if sprite_3d.get_vframes() != sprite_mesh_instance.get_vframes():
		differences.push_back(msg % "vframes")

	if sprite_3d.get_frame() != sprite_mesh_instance.get_frame():
		differences.push_back(msg % "frame")

	if sprite_3d.get_frame_coords() != sprite_mesh_instance.get_frame_coords():
		differences.push_back(msg % "frame_coords")

	if sprite_3d.get_region_enabled() != sprite_mesh_instance.get_region_enabled():
		differences.push_back(msg % "region_enabled")

	if sprite_3d.get_region_rect() != Rect2(sprite_mesh_instance.get_region_rect()):
		differences.push_back(msg % "region_rect")

	return differences
