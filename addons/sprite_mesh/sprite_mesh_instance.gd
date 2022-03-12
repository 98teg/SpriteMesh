tool
class_name SpriteMeshInstance, "icons/sprite_mesh_instance.png"
extends MeshInstance

#####################
# Public properties #
#####################

var texture setget set_texture, get_texture
# Mesh properties
var mesh_depth := 1.0 setget set_mesh_depth, get_mesh_depth
var mesh_pixel_size := 0.01 setget set_mesh_pixel_size, get_mesh_pixel_size
var mesh_double_sided := true setget set_mesh_double_sided, get_mesh_double_sided
# Animation
var animation_hframes := 1 setget set_animation_hframes, get_animation_hframes
var animation_vframes := 1 setget set_animation_vframes, get_animation_vframes
var animation_frame := 0 setget set_animation_frame, get_animation_frame
var animation_frame_coords := Vector2(0, 0) setget set_animation_frame_coords, get_animation_frame_coords
# Position
var position_centered := true setget set_position_centered, get_position_centered
var position_offset := Vector3.ZERO setget set_position_offset, get_position_offset
var position_flip_h := false setget set_position_flip_h, get_position_flip_h
var position_flip_v := false setget set_position_flip_v, get_position_flip_v
var position_axis : int = Vector3.AXIS_Z setget set_position_axis, get_position_axis
# Region
var region_enabled := false setget set_region_enabled, get_region_enabled
var region_rect := Rect2(0, 0, 1, 1) setget set_region_rect, get_region_rect
# Generation parameters
var generation_alpha_threshold := 0.0 setget set_generation_alpha_threshold, get_generation_alpha_threshold
var generation_uv_correction := 0.0 setget set_generation_uv_correction, get_generation_uv_correction
# Generated SpriteMesh
var generated_sprite_mesh := SpriteMesh.new() setget set_generated_sprite_mesh, get_generated_sprite_mesh

######################
# Private properties #
######################

var _pending_update := false
var _seconds_left := 0.0

##################
# Public methods #
##################

func update_sprite_mesh() -> void:
	if _pending_update:
		_pending_update = false
		_generate_model()

###########
# Getters #
###########

func get_mesh_with_index(index: int) -> Mesh:
	var size := generated_sprite_mesh.meshes.size()
	if(size == 0):
		return Mesh.new()
	return generated_sprite_mesh.meshes[index % size]


func get_texture():
	return texture


func get_mesh_depth() -> float:
	return mesh_depth


func get_mesh_pixel_size() -> float:
	return mesh_pixel_size


func get_mesh_double_sided() -> bool:
	return mesh_double_sided


func get_animation_hframes() -> int:
	return animation_hframes


func get_animation_vframes() -> int:
	return animation_vframes


func get_animation_frame() -> int:
	return animation_frame


func get_animation_frame_coords() -> Vector2:
	return animation_frame_coords


func get_position_centered() -> bool:
	return position_centered


func get_position_offset() -> Vector3:
	return position_offset


func get_position_flip_h() -> bool:
	return position_flip_h


func get_position_flip_v() -> bool:
	return position_flip_v


func get_position_axis() -> int:
	return position_axis


func get_region_enabled() -> bool:
	return region_enabled


func get_region_rect() -> Rect2:
	return region_rect


func get_generation_alpha_threshold() -> float:
	return generation_alpha_threshold


func get_generation_uv_correction() -> float:
	return generation_uv_correction


func get_generated_sprite_mesh() -> SpriteMesh:
	return generated_sprite_mesh

###########
# Setters #
###########

func set_texture(new_texture: Texture) -> void:
	texture = new_texture

	_request_update()


func set_mesh_depth(new_mesh_depth: float) -> void:
	mesh_depth = clamp(new_mesh_depth, 0, 128)

	_request_update()


func set_mesh_pixel_size(new_mesh_pixel_size: float) -> void:
	mesh_pixel_size = clamp(new_mesh_pixel_size, 0, 128)

	_request_update()


func set_mesh_double_sided(new_mesh_double_sided: bool) -> void:
	mesh_double_sided = new_mesh_double_sided

	_request_update()


func set_animation_hframes(new_animation_hframes: int) -> void:
	animation_hframes = int(clamp(new_animation_hframes, 1, 16384))

	_request_update()


func set_animation_vframes(new_animation_vframes: int) -> void:
	animation_vframes = int(clamp(new_animation_vframes, 1, 16384))

	_request_update()


func set_animation_frame(new_animation_frame: int) -> void:
	animation_frame = int(abs(new_animation_frame)) % _n_of_frames()

	animation_frame_coords.x = animation_frame % animation_hframes
	animation_frame_coords.y = animation_frame / animation_hframes

	if generated_sprite_mesh.meshes.size() == 0:
		return

	mesh = get_mesh_with_index(animation_frame)


func set_animation_frame_coords(new_animation_frame_coords: Vector2) -> void:
	var coord_x := int(new_animation_frame_coords.x)
	var coord_y := int(new_animation_frame_coords.y)

	coord_x = coord_x if coord_x >= 0 else animation_hframes + coord_x
	coord_y = coord_y if coord_y >= 0 else animation_vframes + coord_y

	var x := coord_x % animation_hframes
	var y := coord_y % animation_vframes

	set_animation_frame(x + y * animation_hframes)


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
	position_axis = int(clamp(new_position_axis, 0, 2))

	_request_update()


func set_region_enabled(new_region_enabled: bool) -> void:
	region_enabled = new_region_enabled

	_request_update()


func set_region_rect(new_region_rect: Rect2) -> void:
	if texture == null:
		region_rect = Rect2(0, 0, 1, 1)
		return

	var pos_x := int(clamp(new_region_rect.position.x, 0, _get_texture_width() - 1))
	var pos_y := int(clamp(new_region_rect.position.y, 0, _get_texture_height() - 1))
	var size_x := int(clamp(new_region_rect.size.x, 1, _get_texture_width() - pos_x))
	var size_y := int(clamp(new_region_rect.size.y, 1, _get_texture_height() - pos_y))

	region_rect.position.x = pos_x
	region_rect.position.y = pos_y
	region_rect.size.x = size_x
	region_rect.size.y = size_y

	_request_update()


func set_generation_alpha_threshold(new_generation_alpha_threshold: float) -> void:
	generation_alpha_threshold = clamp(new_generation_alpha_threshold, 0, 1)

	_request_update()


func set_generation_uv_correction(new_generation_uv_correction: float) -> void:
	generation_uv_correction = clamp(new_generation_uv_correction, 0, 30)

	_request_update()


func set_generated_sprite_mesh(new_generated_sprite_mesh: SpriteMesh) -> void:
	generated_sprite_mesh = new_generated_sprite_mesh

	if generated_sprite_mesh == null:
		_clear_model()
	else:
		_connect_resource()
		_apply_generated_sprite_mesh()

###################
# Properties list #
###################

func _get_property_list() -> Array:
	var properties = []

	_add_main_section(properties)
	_add_mesh_properties_section(properties)
	_add_animation_section(properties)
	_add_position_section(properties)
	_add_region_section(properties)
	_add_generation_parameters_section(properties)
	_add_generated_sprite_mesh_section(properties)

	return properties


func _add_main_section(properties: Array) -> void:
	properties.append({
		"name": "SpriteMeshInstance",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "texture",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})


func _add_mesh_properties_section(properties: Array) -> void:
	properties.append({
		"name": "Mesh Properties",
		"type": TYPE_NIL,
		"hint_string": "mesh_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "mesh_depth",
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,128"
	})
	properties.append({
		"name": "mesh_pixel_size",
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,128"
	})
	properties.append({
		"name": "mesh_double_sided",
		"type": TYPE_BOOL
	})


func _add_animation_section(properties: Array) -> void:
	properties.append({
		"name": "Animation",
		"type": TYPE_NIL,
		"hint_string": "animation_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "animation_hframes",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,16384"
	})
	properties.append({
		"name": "animation_vframes",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,16384"
	})
	properties.append({
		"name": "animation_frame",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,16384"
	})
	properties.append({
		"name": "animation_frame_coords",
		"type": TYPE_VECTOR2,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,16383,1"
	})


func _add_position_section(properties: Array) -> void:
	properties.append({
		"name": "Position",
		"type": TYPE_NIL,
		"hint_string": "position_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "position_centered",
		"type": TYPE_BOOL
	})
	properties.append({
		"name": "position_offset",
		"type": TYPE_VECTOR3
	})
	properties.append({
		"name": "position_flip_h",
		"type": TYPE_BOOL
	})
	properties.append({
		"name": "position_flip_v",
		"type": TYPE_BOOL
	})
	properties.append({
		"name": "position_axis",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "X-Axis,Y-Axis,Z-Axis"
	})


func _add_region_section(properties: Array) -> void:
	properties.append({
		"name": "Region",
		"type": TYPE_NIL,
		"hint_string": "region_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "region_enabled",
		"type": TYPE_BOOL
	})
	properties.append({
		"name": "region_rect",
		"type": TYPE_RECT2
	})


func _add_generation_parameters_section(properties: Array) -> void:
	properties.append({
		"name": "Generation Parameters",
		"type": TYPE_NIL,
		"hint_string": "generation_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "generation_alpha_threshold",
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,1"
	})
	properties.append({
		"name": "generation_uv_correction",
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,30"
	})


func _add_generated_sprite_mesh_section(properties: Array) -> void:
	properties.append({
		"name": "Generated SpriteMesh",
		"type": TYPE_NIL,
		"hint_string": "generated_",
		"usage": PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		"name": "generated_sprite_mesh",
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Resource"
	})

#########
# Ready #
#########

func _ready():
	_connect_resource()

	_pending_update = false

##############
# Processing #
##############

func _process(delta):
	if Engine.editor_hint and _pending_update:
		if _seconds_left <= 0:
			_pending_update = false
			_generate_model()
		else:
			_seconds_left -= delta


func _request_update() -> void:
	_pending_update = true

	if Engine.editor_hint:
		_seconds_left = 3

####################
# Model generation #
####################

func _generate_model() -> void:
	if texture == null:
		return

	_generate_meshes()
	_generate_material()

	generated_sprite_mesh.emit_changed()


func _generate_meshes() -> void:
	generated_sprite_mesh.meshes.clear()

	var st := SurfaceTool.new()

	while _current_frame() < _n_of_frames():
		st.clear()
		_generate_mesh(st)


func _generate_mesh(st: SurfaceTool) -> void:
	var image := _get_frame_image(_current_frame())

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	_draw_sprite_faces(st, image)
	_draw_depth_faces(st, image)

	st.generate_normals()
	st.index()

	generated_sprite_mesh.meshes.append(st.commit())


func _generate_material() -> void:
	generated_sprite_mesh.material.set_texture(
		SpatialMaterial.TEXTURE_ALBEDO,
		texture
	)

func _apply_generated_sprite_mesh() -> void:
	mesh = get_mesh_with_index(animation_frame)
	if get_surface_material_count() != 0:
		set_surface_material(0, generated_sprite_mesh.material)

#####################
# Draw sprite faces #
#####################

func _draw_sprite_faces(st: SurfaceTool, image: Image) -> void:
	var rendered := []
	for x in range(_get_frame_width()):
		rendered.append([])
		for y in range(_get_frame_height()):
			rendered[x].append(false)

	for x in range(_get_frame_width()):
		for y in range(_get_frame_height()):
			if not _drawn_pixel(image, rendered, x, y):
				_draw_sprite_faces_quad(st, image, rendered, x, y)


func _draw_sprite_faces_quad(st: SurfaceTool, image: Image, rendered: Array, x0: int, y0: int) -> void:
	var w := 0
	var check_w := true
	var h := 0
	var check_h := true

	while check_w or check_h:
		if check_w:
			w += 1

			if x0 + w < _get_frame_width():
				for y in range(y0, y0 + h + 1):
					if _drawn_pixel(image, rendered, x0 + w, y):
						check_w = false
						w -= 1
						break
			else:
				check_w = false
				w -= 1
		if check_h:
			h += 1

			if y0 + h < _get_frame_height():
				for x in range(x0, x0 + w + 1):
					if _drawn_pixel(image, rendered, x, y0 + h):
						check_h = false
						h -= 1
						break
			else:
				check_h = false
				h -= 1

	var x1 := x0 + w
	var y1 := y0 + h

	var front_v := _get_front_v_quad(x0, x1, y0, y1)
	var front_uv := _get_uv_quad(x0, x1, y0, y1)

	_draw_quad(st, front_v, front_uv)

	if mesh_double_sided:
		var back_v := _get_back_v_quad(x0, x1, y0, y1)
		var back_uv := _flip_h(_get_uv_quad(x0, x1, y0, y1))

		_draw_quad(st, back_v, back_uv)

	for x in range(x0, x1 + 1):
		for y in range(y0, y1 + 1):
			rendered[x][y] = true


func _drawn_pixel(image: Image, rendered: Array, x: int, y: int) -> bool:
	return not _visible_pixel(image, x, y) or rendered[x][y]

#####################
# Draw depth faces #
#####################

func _draw_depth_faces(st: SurfaceTool, image: Image) -> void:
	_draw_left_depth_faces(st, image)
	_draw_right_depth_faces(st, image)
	_draw_up_depth_faces(st, image)
	_draw_down_depth_faces(st, image)


func _draw_left_depth_faces(st: SurfaceTool, image: Image) -> void:
	for x in range(_get_frame_width()):
		var y0 := 0

		for y in range(_get_frame_height()):
			var curr = _left_face_visible(image, x, y)

			if y < _get_frame_height() - 1:
				if curr == _left_face_visible(image, x, y + 1):
					continue

			if curr:
				_draw_quad(st, _get_left_v_quad(x, y0, y), _get_uv_quad(x, x, y0, y))
			else:
				y0 = y + 1


func _left_face_visible(image: Image, x: int, y: int) -> bool:
	if x == 0:
		return _visible_pixel(image, x, y)
	elif image.get_pixel(x, y).a != 0:
		return _visible_pixel(image, x, y) and not _visible_pixel(image, x - 1, y)

	return false


func _draw_right_depth_faces(st: SurfaceTool, image: Image) -> void:
	for x in range(_get_frame_width()):
		var y0 := 0

		for y in range(_get_frame_height()):
			var curr = _right_face_visible(image, x, y)

			if y < _get_frame_height() - 1:
				if curr == _right_face_visible(image, x, y + 1):
					continue

			if curr:
				_draw_quad(st, _get_right_v_quad(x, y0, y), _get_uv_quad(x, x, y0, y))
			else:
				y0 = y + 1


func _right_face_visible(image: Image, x: int, y: int) -> bool:
	if x == image.get_width() - 1:
		return _visible_pixel(image, x, y)
	elif image.get_pixel(x, y).a != 0:
		return _visible_pixel(image, x, y) and not _visible_pixel(image, x + 1, y)

	return false


func _draw_up_depth_faces(st: SurfaceTool, image: Image) -> void:
	for y in range(_get_frame_height()):
		var x0 := 0

		for x in range(_get_frame_width()):
			var curr = _up_face_visible(image, x, y)

			if x < _get_frame_width() - 1:
				if curr == _up_face_visible(image, x + 1, y):
					continue

			if curr:
				_draw_quad(st, _get_up_v_quad(x0, x, y), _get_uv_quad(x0, x, y, y))
			else:
				x0 = x + 1


func _up_face_visible(image: Image, x: int, y: int) -> bool:
	if y == 0:
		return _visible_pixel(image, x, y)
	elif image.get_pixel(x, y).a != 0:
		return _visible_pixel(image, x, y) and not _visible_pixel(image, x, y - 1)

	return false


func _draw_down_depth_faces(st: SurfaceTool, image: Image) -> void:
	for y in range(_get_frame_height()):
		var x0 := 0

		for x in range(_get_frame_width()):
			var curr = _down_face_visible(image, x, y)

			if x < _get_frame_width() - 1:
				if curr == _down_face_visible(image, x + 1, y):
					continue

			if curr:
				_draw_quad(st, _get_down_v_quad(x0, x, y), _get_uv_quad(x0, x, y, y))
			else:
				x0 = x + 1


func _down_face_visible(image: Image, x: int, y: int) -> bool:
	if y == image.get_height() - 1:
		return _visible_pixel(image, x, y)
	elif image.get_pixel(x, y).a != 0:
		return _visible_pixel(image, x, y) and not _visible_pixel(image, x, y + 1)

	return false

###########
# Helpers #
###########

func _connect_resource() -> void:
	if not generated_sprite_mesh.is_connected("changed", self, "_apply_generated_sprite_mesh"):
		generated_sprite_mesh.connect("changed", self, "_apply_generated_sprite_mesh")


func _clear_model() -> void:
	if get_surface_material_count() != 0:
		set_surface_material(0, null)

	mesh = null


func _draw_quad(st: SurfaceTool, v: Array, uv: Array) -> void:
	if position_flip_h:
		v = _flip_h(v)
		uv = _flip_h(uv)

	if position_flip_v:
		v = _flip_v(v)
		uv = _flip_v(uv)

	st.add_uv(uv[0])
	st.add_vertex(v[0])
	st.add_uv(uv[1])
	st.add_vertex(v[1])
	st.add_uv(uv[2])
	st.add_vertex(v[2])

	st.add_uv(uv[0])
	st.add_vertex(v[0])
	st.add_uv(uv[2])
	st.add_vertex(v[2])
	st.add_uv(uv[3])
	st.add_vertex(v[3])


func _flip_h(array: Array) -> Array:
	return [array[1], array[0], array[3], array[2]]


func _flip_v(array: Array) -> Array:
	return [array[3], array[2], array[1], array[0]]


func _visible_pixel(image: Image, x: int, y: int) -> bool:
	return image.get_pixel(x, y).a > generation_alpha_threshold


func _current_frame() -> int:
	return generated_sprite_mesh.meshes.size()


func _n_of_frames() -> int:
	return animation_hframes * animation_vframes

######################
# Vertices providers #
######################

func _get_v(x: int, y: int, z: int) -> Vector3:
	# Flip
	if position_flip_h:
		x = _get_frame_width() - x

	if position_flip_v:
		y = _get_frame_height() - y

	# Centered
	var v := Vector3.ZERO
	if position_centered:
		v.x = x - (_get_frame_width() / 2.0)
		v.y = (_get_frame_height() / 2.0) - y
		v.z = (z + 0.5) * mesh_depth
	else:
		v.x = x
		v.y = _get_frame_height() - y
		v.z = z * mesh_depth

	# Offset
	v += position_offset

	# Axis
	match position_axis:
		Vector3.AXIS_X:
			v = v.rotated(Vector3.UP, 0.5 * PI)
		Vector3.AXIS_Y:
			v = v.rotated(Vector3.LEFT, 0.5 * PI)

	return v * mesh_pixel_size


func _get_front_v_quad(x0: int,  x1: int, y0: int, y1: int) -> Array:
	x1 += 1
	y1 += 1

	var v0 := _get_v(x0, y0, 0)
	var v1 := _get_v(x1, y0, 0)
	var v2 := _get_v(x1, y1, 0)
	var v3 := _get_v(x0, y1, 0)

	return [v0, v1, v2, v3]


func _get_back_v_quad(x0: int, x1: int, y0: int, y1: int) -> Array:
	x1 += 1
	y1 += 1

	var v0 := _get_v(x1, y0, -1)
	var v1 := _get_v(x0, y0, -1)
	var v2 := _get_v(x0, y1, -1)
	var v3 := _get_v(x1, y1, -1)

	return [v0, v1, v2, v3]


func _get_left_v_quad(x: int, y0: int, y1: int) -> Array:
	y1 += 1

	var v0 := _get_v(x, y0, -1)
	var v1 := _get_v(x, y0, 0)
	var v2 := _get_v(x, y1, 0)
	var v3 := _get_v(x, y1, -1)

	return [v0, v1, v2, v3]


func _get_right_v_quad(x: int, y0: int, y1: int) -> Array:
	x += 1
	y1 += 1

	var v0 := _get_v(x, y0, 0)
	var v1 := _get_v(x, y0, -1)
	var v2 := _get_v(x, y1, -1)
	var v3 := _get_v(x, y1, 0)

	return [v0, v1, v2, v3]


func _get_up_v_quad(x0: int, x1: int, y: int) -> Array:
	x1 += 1

	var v0 := _get_v(x0, y, -1)
	var v1 := _get_v(x1, y, -1)
	var v2 := _get_v(x1, y, 0)
	var v3 := _get_v(x0, y, 0)

	return [v0, v1, v2, v3]


func _get_down_v_quad(x0: int, x1: int, y: int) -> Array:
	x1 += 1
	y += 1

	var v0 := _get_v(x0, y, 0)
	var v1 := _get_v(x1, y, 0)
	var v2 := _get_v(x1, y, -1)
	var v3 := _get_v(x0, y, -1)

	return [v0, v1, v2, v3]

################
# UV providers #
################

func _get_uv(x: int, y: int) -> Vector2:
	# Frame
	var x0 = (_current_frame() % animation_hframes) * _get_frame_width()
	var y0 = (_current_frame() / animation_hframes) * _get_frame_height()

	# Region
	if region_enabled:
		x0 += region_rect.position.x
		y0 += region_rect.position.y

	return Vector2(
		float(x0 + x) / _get_texture_width(),
		float(y0 + y) / _get_texture_height()
	)


func _get_uv_quad(x0: int, x1: int, y0: int, y1: int) -> Array:
	var x_corr := 0.0
	var y_corr := 0.0

	if abs(x0 - x1) <= 1:
		x_corr = 1.0 / (_get_texture_width() * 2)
	else:
		x_corr = 1.0 / (_get_texture_width() * 30) * generation_uv_correction

	if abs(y0 - y1) <= 1:
		y_corr = 1.0 / (_get_texture_height() * 2)
	else:
		y_corr = 1.0 / (_get_texture_height() * 30) * generation_uv_correction

	x1 += 1
	y1 += 1

	var uv0 = _get_uv(x0, y0) + Vector2(x_corr, y_corr)
	var uv1 = _get_uv(x1, y0) + Vector2(-x_corr, y_corr)
	var uv2 = _get_uv(x1, y1) + Vector2(-x_corr, -y_corr)
	var uv3 = _get_uv(x0, y1) + Vector2(x_corr, -y_corr)

	return [uv0, uv1, uv2, uv3]

########################
# Accessing frame data #
########################

func _get_frame_image(frame: int) -> Image:
	var image = texture.get_data()
	image.decompress()

	# Region
	if region_enabled:
		image = image.get_rect(region_rect)

	# Frame
	var pos := Vector2(
		frame % animation_hframes * _get_frame_width(),
		frame / animation_hframes * _get_frame_height()
	)
	var size := Vector2(_get_frame_width(), _get_frame_height())
	image = image.get_rect(Rect2(pos, size))

	image.lock()

	return image


func _get_texture_width() -> int:
	return texture.get_width()


func _get_region_width() -> int:
	return _get_texture_width() if not region_enabled else int(region_rect.size.x)


func _get_frame_width() -> int:
	return _get_region_width() / animation_hframes


func _get_texture_height() -> int:
	return texture.get_height()


func _get_region_height() -> int:
	return _get_texture_height() if not region_enabled else int(region_rect.size.y)


func _get_frame_height() -> int:
	return _get_region_height() / animation_vframes
