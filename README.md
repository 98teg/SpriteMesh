![Sprite Mesh Banner](./doc/images/sprite_mesh_banner.png)

# Sprite Mesh

SpriteMesh is a plugin for Godot that allows you to create 3D meshes based on a 2D sprite. It adds two new classes, [`SpriteMesh`](#class-spritemesh) and [`SpriteMeshInstance`](#class-spritemeshinstance). [`SpriteMesh`](#class-spritemesh) is a [`Resource`](https://docs.godotengine.org/en/stable/classes/class_resource.html#class-resource) that contains an array of meshes and their material. [`SpriteMeshInstance`](#class-spritemeshinstance), which inherit from [`MeshInstance`](https://docs.godotengine.org/en/stable/classes/class_meshinstance.html?highlight=MeshInstance), is used to create the meshes based on the sprite.

[`SpriteMeshInstance`](#class-spritemeshinstance) can also be used to display the generated meshes on the scene. It has the benefit over [`MeshInstance`](https://docs.godotengine.org/en/stable/classes/class_meshinstance.html?highlight=MeshInstance) in that it adds support for animations in which each frame is a different mesh, as seen in the example below.

![Animation RPG Demo](./doc/images/example_rpg_animation.gif)

The algorithm [`SpriteMeshInstance`](#class-spritemeshinstance) uses to generate the meshes is a bit demanding. It is for this reason that I do not recommend executing it frequently. However, it has the benefit that the mesh it produces tends to optimise the number of tris. In this image, you can see the result of this algorithm.

![Algorithm Result](./doc/images/result.png)

## How to use it

There are two ways of using this plugin, via the editor or code. For both of them, you would need to include the folder `sprite_mesh` of this project into the `addons` directory of your Godot project. Then click the `Project` dropdown, select `Project Settings...` and go to the `Plugins` tab. Lastly, click on the `Active` check box at the SpriteMesh row.

### Using the editor

I recommend this method if you don't need to generate the meshes procedurally. Using the editor, the algorithm would not be executed at runtime.

1. Instantiate a [`SpriteMeshInstance`](#class-spritemeshinstance) in your scene.
2. Assign the texture for your model.
3. Change any of the properties, if needed. When you change a property, you need to wait three seconds for the editor to update the meshes. This behaviour is intended, as it provides a better user experience.
4. Save or copy the generated mesh if you want to use it in [`MeshInstance`](https://docs.godotengine.org/en/stable/classes/class_meshinstance.html?highlight=MeshInstance) nodes.
5. Save or copy the generated material if you want to use it in [`MeshInstance`](https://docs.godotengine.org/en/stable/classes/class_meshinstance.html?highlight=MeshInstance) nodes. Remember to make it unique if you reuse this [`SpriteMeshInstance`](#class-spritemeshinstance) to generate other meshes.

If you want to use animations and pretend to use [`SpriteMeshInstance`](#class-spritemeshinstance) nodes in your scene instead, you can save or copy the [`SpriteMesh`](#class-spritemesh) and assign it to other [`SpriteMeshInstance`](#class-spritemeshinstance) nodes. It is more memory efficient than creating another [`SpriteMeshInstance`](#class-spritemeshinstance) and setting the same texture.

![Editor Usage](./doc/images/editor_usage.png)

### Using code

I recommend this method if you need to generate the meshes procedurally. Bellow is an example of how to create them.

![Code Usage](./doc/images/code_usage.png)

Even if this option is available, I recommend only executing it on methods that are not called frequently, such as `_ready`. If you want to, for example, flip a character sprite, it is better to just rotate the model than changing the `position_flip_h` property and regenerating it. The only properties meant to change frequently at runtime are `animation_frame` and `animation_frame_coords`. And as such, they don't require to call `update_sprite_mesh` to be applied.

## Class `SpriteMesh`

[`SpriteMesh`](#class-spritemesh) is a [`Resource`](https://docs.godotengine.org/en/stable/classes/class_resource.html#class-resource) that contains an array of meshes and their material. It has two properties:

| Name | Description |
|-|-|
| **meshes** | Array of meshes. Each mesh of the array represents a frame of the animation. |
| **material** | The meshes' material. [`SpriteMeshInstance`](#class-spritemeshinstance) only sets its albedo texture, so you can freely change any other property. |
## Class `SpriteMeshInstance`

[`SpriteMeshInstance`](#class-spritemeshinstance), which inherit from [`MeshInstance`](https://docs.godotengine.org/en/stable/classes/class_meshinstance.html?highlight=MeshInstance), is used to create the meshes based on the sprite. It is inspired by [`Sprite3D`](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html?highlight=sprite3d), so many of its properties behave similarly.

### Properties

The public properties of this class are:

| Name | Description | Default <br> Setter <br> Getter |
|-|-|-|
| **texture** | Texture object to draw. | `null` <br> set_texture <br> get_texture |
| **mesh_depth** | Depth of the mesh, measured in pixels. | `1.0` <br> set_mesh_depth <br> get_mesh_depth |
| **mesh_pixel_size** | The size of one pixel's width on the sprite to scale it in 3D. | `0.01` <br> set_mesh_pixel_size <br> get_mesh_pixel_size |
| **mesh_double_sided** | If `true`, the mesh would have a back face, if `false`, it is invisible when looking at it from behind. | `true` <br> set_mesh_double_sided <br> get_mesh_double_sided |
| **animation_hframes** | The number of columns in the sprite sheet. | `1` <br> set_animation_hframes <br> get_animation_hframes |
| **animation_vframes** | The number of rows in the sprite sheet. | `1` <br> set_animation_vframes <br> get_animation_vframes |
| **animation_frame** | Current frame to display from sprite sheet. | `0` <br> set_animation_frame <br> get_animation_frame |
| **animation_frame_coords** | Coordinates of the frame to display from sprite sheet. This is as an alias for the frame property. | `Vector2(0, 0)` <br> set_animation_frame_coords <br> get_animation_frame_coords |
| **position_centered** | If `true`, mesh will be centered. | `true` <br> set_position_centered <br> get_position_centered |
| **position_offset** | The mesh's generation offset. | `Vector3.ZERO` <br> set_position_offset <br> get_position_offset |
| **position_flip_h** | If `true`, mesh is flipped horizontally. | `false` <br> set_position_flip_h <br> get_position_flip_h |
| **position_flip_v** | If `true`, mesh is flipped vertically. | `false` <br> set_position_flip_v <br> get_position_flip_v |
| **position_axis** | The direction in which the front of the mesh faces. | `Vector3.AXIS_Z` <br> set_position_axis <br> get_position_axis |
| **region_enabled** | If `true`, texture will be cut from a larger atlas texture. See `region_rect`. | `false` <br> set_region_enabled <br> get_region_enabled |
| **region_rect** | The region of the atlas texture to display. `region_enabled` must be `true`. | `Rect2(0, 0, 1, 1)` <br> set_region_rect <br> get_region_rect |
| **generation_alpha_threshold** | The maximum value of alpha for the algorithm to not render a given pixel. | `0.0` <br> set_generation_alpha_threshold <br> get_generation_alpha_threshold |
| **generation_uv_correction** | Sometimes, the UV mapping would leak the colour of adjacent pixels into parts of the mesh where they shouldn't be. As a result, some lines of colour may appear at the border of some faces. <br><br> This property aims to fix this problem. When its value increases, the UV mapping would move inwards. Be careful, as it would also produce misalignment. | `0.0` <br> set_generation_uv_correction <br> get_generation_uv_correction |
| **generated_sprite_mesh** | The result of the algorithm. It would generate automatically in the editor, or after calling `update_sprite_mesh` in code. | `SpriteMesh.new()` <br> set_generated_sprite_mesh <br> get_generated_sprite_mesh |

### Methods

The public methods of this class are:

| Name | Params | Description | Returns |
|-|-|-|-|
| **get_mesh_with_index** | **index -> int:** <br> Index of the mesh. | Returns the mesh that corresponds to a frame of the animation, represented by its index. | **Mesh:** <br> The mesh of the frame. |
| **update_sprite_mesh** | None. | Generates the meshes and material given the current properties. | Nothing. |