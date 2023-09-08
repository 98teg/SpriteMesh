@tool
extends TextureRect


const SIDEPANEL_PATH := "MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer"


var food_examples := [
	preload("res://examples/food/beaf.gd").new(),
	preload("res://examples/food/calamari.gd").new(),
	preload("res://examples/food/fish.gd").new(),
	preload("res://examples/food/fortune_cookie.gd").new(),
	preload("res://examples/food/honey.gd").new(),
	preload("res://examples/food/noodle.gd").new(),
	preload("res://examples/food/octopus.gd").new(),
	preload("res://examples/food/onigiri.gd").new(),
	preload("res://examples/food/shrimp.gd").new(),
	preload("res://examples/food/sushi.gd").new(),
	preload("res://examples/food/sushi2.gd").new(),
	preload("res://examples/food/tea_leaf.gd").new(),
	preload("res://examples/food/yakitori.gd").new(),
]

var weapons_examples := [
	preload("res://examples/weapons/big_sword.gd").new(),
	preload("res://examples/weapons/bone.gd").new(),
	preload("res://examples/weapons/book.gd").new(),
	preload("res://examples/weapons/club.gd").new(),
	preload("res://examples/weapons/lance.gd").new(),
	preload("res://examples/weapons/magic_wand.gd").new(),
	preload("res://examples/weapons/rapier.gd").new(),
	preload("res://examples/weapons/stick.gd").new(),
	preload("res://examples/weapons/sword.gd").new(),
	preload("res://examples/weapons/whip.gd").new(),
]

var characters_examples := [
	preload("res://examples/characters/blue_ninja.gd").new(),
	preload("res://examples/characters/blue_samurai.gd").new(),
	preload("res://examples/characters/boy.gd").new(),
	preload("res://examples/characters/cavegirl.gd").new(),
	preload("res://examples/characters/cavegirl2.gd").new(),
	preload("res://examples/characters/caveman.gd").new(),
	preload("res://examples/characters/caveman2.gd").new(),
	preload("res://examples/characters/child.gd").new(),
	preload("res://examples/characters/dark_ninja.gd").new(),
	preload("res://examples/characters/egg_boy.gd").new(),
	preload("res://examples/characters/egg_girl.gd").new(),
	preload("res://examples/characters/eskimo.gd").new(),
	preload("res://examples/characters/eskimo_ninja.gd").new(),
	preload("res://examples/characters/gold_knight.gd").new(),
	preload("res://examples/characters/gray_ninja.gd").new(),
	preload("res://examples/characters/greenman.gd").new(),
	preload("res://examples/characters/green_ninja.gd").new(),
	preload("res://examples/characters/inspector.gd").new(),
	preload("res://examples/characters/knight.gd").new(),
	preload("res://examples/characters/lion.gd").new(),
	preload("res://examples/characters/masked_ninja.gd").new(),
	preload("res://examples/characters/mask_frog.gd").new(),
	preload("res://examples/characters/master.gd").new(),
	preload("res://examples/characters/monk.gd").new(),
	preload("res://examples/characters/monk2.gd").new(),
	preload("res://examples/characters/noble.gd").new(),
	preload("res://examples/characters/old_man.gd").new(),
	preload("res://examples/characters/old_man2.gd").new(),
	preload("res://examples/characters/old_man3.gd").new(),
	preload("res://examples/characters/old_woman.gd").new(),
	preload("res://examples/characters/princess.gd").new(),
	preload("res://examples/characters/red_ninja2.gd").new(),
	preload("res://examples/characters/red_ninja.gd").new(),
	preload("res://examples/characters/red_samurai.gd").new(),
	preload("res://examples/characters/samurai.gd").new(),
	preload("res://examples/characters/skeleton.gd").new(),
]


@onready var preview := $MarginContainer/HBoxContainer/Preview

@onready var example_option := get_node(SIDEPANEL_PATH + "/VBoxContainer/OptionButton")
@onready var show_sprite_mesh := get_node(SIDEPANEL_PATH + "/HBoxContainer/CheckButton")

@onready var x_slider := get_node(SIDEPANEL_PATH + "/VBoxContainer2/HBoxContainer2/HSlider")
@onready var y_slider := get_node(SIDEPANEL_PATH + "/VBoxContainer2/HBoxContainer3/HSlider")
@onready var z_slider := get_node(SIDEPANEL_PATH + "/VBoxContainer2/HBoxContainer4/HSlider")

@onready var zoom_slider := get_node(SIDEPANEL_PATH + "/VBoxContainer3/HSlider")

@onready var changed_properties := get_node(SIDEPANEL_PATH + "/VBoxContainer4/TextEdit")


func _ready() -> void:
	example_option.clear()

	example_option.add_separator("Food")

	for example in food_examples:
		example_option.add_item(example.name)

	example_option.add_separator("Weapons")

	for example in weapons_examples:
		example_option.add_item(example.name)

	example_option.add_separator("Characters")

	for example in characters_examples:
		example_option.add_item(example.name)

	update_item()


func update_item(_index = null) -> void:
	var example: SpriteMeshExample
	var index = example_option.selected

	index -= 1
	if index < food_examples.size():
		example = food_examples[index]
	else:
		index -= food_examples.size() + 1
		if index < weapons_examples.size():
			example = weapons_examples[index]
		else:
			index -= weapons_examples.size() + 1
			example = characters_examples[index]

	if show_sprite_mesh.button_pressed:
		preview.set_preview_name("Sprite Mesh")
		preview.set_item(example.sprite_mesh_instance)
	else:
		preview.set_preview_name("Sprite 3D")
		preview.set_item(example.sprite_3d)

	changed_properties.text = ''

	for property in example.changed_properties:
		changed_properties.text += property + '\n'


func reset_rotation() -> void:
	x_slider.value = 0.5
	y_slider.value = 0.5
	z_slider.value = 0.5

	zoom_slider.value = 0.5


func update_x_rotation(value: float) -> void:
	preview.set_item_rotation_x((value - 0.5) * 2 * PI)


func update_y_rotation(value: float) -> void:
	preview.set_item_rotation_y(((value - 1) * (2 * PI)) if (value > 0.5) else (value * (2 * PI)))


func update_z_rotation(value: float) -> void:
	preview.set_item_rotation_z((value - 0.5) * 2 * PI)


func rotation_updated(value: Vector3) -> void:
	x_slider.value = (value.x / (2 * PI)) + 0.5
	y_slider.value = ((value.y / (2 * PI)) + 1) if (value.y <= 0) else (value.y / (2 * PI))
	z_slider.value = (value.z / (2 * PI)) + 0.5


func update_zoom(value: float) -> void:
	preview.set_camera_zoom(value)


func zoom_updated(value: float) -> void:
	zoom_slider.value = value
