@tool
extends PanelContainer


signal item_rotation_changed(value: Vector3)
signal camera_zoom_changed(value: float)


@export var preview_name := "": set = set_preview_name

var mouse_controls_active := false
var rotating_item := false
var camera_zoom := 0.5: set = set_camera_zoom
var camera_zoom_increment := 0.05

@onready var label := $MarginContainer/PanelContainer/Label
@onready var node_3d := $SubViewportContainer/SubViewport/Node3D
@onready var camera := $SubViewportContainer/SubViewport/Camera3D


func _input(event):
	if not mouse_controls_active:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_MASK_LEFT and rotating_item:
				rotating_item = false
		return

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MASK_LEFT:
				rotating_item = event.pressed
			MOUSE_BUTTON_WHEEL_UP:
				set_camera_zoom(camera_zoom + camera_zoom_increment)
			MOUSE_BUTTON_WHEEL_DOWN:
				set_camera_zoom(camera_zoom - camera_zoom_increment)
	elif event is InputEventMouseMotion and rotating_item:
		var relative: Vector2 = event.relative
		if relative != Vector2.ZERO:
			var orthogonal := relative.orthogonal()
			var axis := Vector3(-orthogonal.x, -orthogonal.y, 0).normalized()
			var angle := clampf(
				(relative / (size * lerp(camera_zoom, 0.25, 0.5))).length() * PI,
				0.0,
				PI
			)

			node_3d.rotate(axis, angle)
			emit_signal("item_rotation_changed", node_3d.rotation)


func set_preview_name(new_preview_name: String) -> void:
	preview_name = new_preview_name

	if not is_inside_tree():
		await ready

	label.text = preview_name


func set_item(item) -> void:
	for child in node_3d.get_children():
		item.frame = child.frame
		node_3d.remove_child(child)

	node_3d.add_child(item)
	update_camera_position()


func set_item_rotation_x(rotation_x: float) -> void:
	set_item_rotation(Vector3(rotation_x, node_3d.rotation.y, node_3d.rotation.z))


func set_item_rotation_y(rotation_y: float) -> void:
	set_item_rotation(Vector3(node_3d.rotation.x, rotation_y, node_3d.rotation.z))


func set_item_rotation_z(rotation_z: float) -> void:
	set_item_rotation(Vector3(node_3d.rotation.x, node_3d.rotation.y, rotation_z))


func set_item_rotation(new_item_rotation: Vector3) -> void:
	if node_3d.rotation == new_item_rotation:
		return

	node_3d.rotation = new_item_rotation
	emit_signal("item_rotation_changed", new_item_rotation)


func set_camera_zoom(new_camera_zoom: float) -> void:
	new_camera_zoom = clampf(new_camera_zoom, 0.0, 1.0)
	if camera_zoom == new_camera_zoom:
		return

	camera_zoom = new_camera_zoom
	update_camera_position()
	emit_signal("camera_zoom_changed", camera_zoom)


func update_camera_position() -> void:
	camera.position.z = lerpf(get_max_camera_distance(), get_min_camera_distance(), camera_zoom)


func activate_mouse_controls() -> void:
	mouse_controls_active = true


func deactivate_mouse_controls() -> void:
	mouse_controls_active = false


func increase_frame():
	var item = node_3d.get_child(0)

	if item is Sprite3D or item is SpriteMeshInstance:
		if item.frame_coords.y < item.vframes - 1:
			item.frame_coords.y += 1
		elif item.frame_coords.x < item.hframes - 1:
			item.frame_coords.x += 1
			item.frame_coords.y = 0
		else:
			item.frame_coords = Vector2i.ZERO


func get_max_camera_distance() -> float:
	return -2 * get_item_width() - 1 * get_item_width()


func get_min_camera_distance() -> float:
	return -2 * get_item_width() + 1 * get_item_width()


func get_item_height() -> float:
	var item = node_3d.get_child(0)

	if item is Sprite3D or item is SpriteMeshInstance:
		if item.region_enabled:
			return item.region_rect.size.y / item.get_vframes() * item.pixel_size

		return item.texture.get_height() / item.get_vframes() * item.pixel_size

	return 0


func get_item_width() -> float:
	var item = node_3d.get_child(0)

	if item is Sprite3D or item is SpriteMeshInstance:
		if item.region_enabled:
			return item.region_rect.size.x / item.get_hframes() * item.pixel_size

		return item.texture.get_width() / item.get_hframes() * item.pixel_size

	return 0


func get_item_depth() -> float:
	var item = node_3d.get_child(0)

	if item is Sprite3D:
		return 0

	if item is SpriteMeshInstance:
		var typed_item := item as SpriteMeshInstance
		return typed_item.pixel_size

	return 0
