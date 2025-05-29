extends Resource

class_name ArmaData

@export var nombre: String
@export var sprite: Texture2D
@export var damage: int
@export var tiempoDisparo: float
@export var arma_escena: PackedScene = load("res://scenes/game/weapon.tscn")
@export var _bullet_type : String
#@export var _rarety : int
@export var _texture : CompressedTexture2D
@export var bullet_scene: PackedScene
@export var costo : int

@export var _rarety: int = 0:   # comun = 0, rara = 1, épica = 2 y legendaria = 3
	set(value):
		_rarety = clamp(value, 0, 4)

# Señales
signal weapon_updated

# getters
func get_cost() -> float:
	return costo
	
func get_rarety() -> float:
	return _rarety
