@tool
class_name GrassTuft
extends Node2D

## Interactive swaying grass tuft / wildflower prop.

@export_enum("tall", "wildflower_gold", "wildflower_blue", "clover", "moss_rock", "boulder") var tuft_type: String = "tall":
	set(val):
		tuft_type = val
		_update_texture()

@export var sway_strength: float = 3.5:
	set(val):
		sway_strength = val
		_update_shader_params()

@export var sway_speed: float = 2.0:
	set(val):
		sway_speed = val
		_update_shader_params()

var _sprite: Sprite2D

const TEXTURE_PATHS := {
	"tall": "res://assets/village_top_down/foliage/grass_tuft_tall.png",
	"wildflower_gold": "res://assets/village_top_down/foliage/grass_wildflower_gold.png",
	"wildflower_blue": "res://assets/village_top_down/foliage/grass_wildflower_blue.png",
	"clover": "res://assets/village_top_down/foliage/grass_clover.png",
	"moss_rock": "res://assets/village_top_down/foliage/grass_moss_rock.png",
	"boulder": "res://assets/village_top_down/foliage/grass_boulder.png",
}


func _ready() -> void:
	_sprite = get_node_or_null("Sprite2D")
	_update_texture()
	_update_shader_params()


func _update_texture() -> void:
	if not _sprite:
		_sprite = get_node_or_null("Sprite2D")
	if _sprite and TEXTURE_PATHS.has(tuft_type):
		var path: String = TEXTURE_PATHS[tuft_type]
		if ResourceLoader.exists(path):
			_sprite.texture = load(path)


func _update_shader_params() -> void:
	if not _sprite:
		_sprite = get_node_or_null("Sprite2D")
	if _sprite and _sprite.material is ShaderMaterial:
		var mat: ShaderMaterial = _sprite.material
		if tuft_type in ["moss_rock", "boulder"]:
			mat.set_shader_parameter("sway_strength", 0.0)
		else:
			mat.set_shader_parameter("sway_strength", sway_strength)
			mat.set_shader_parameter("speed", sway_speed)
