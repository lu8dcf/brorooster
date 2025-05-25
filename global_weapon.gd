extends Resource
class_name WeaponData

# Propiedades exportadas para configurar en el editor
@export var _id: int = 0
@export var _display_name: String = "Arma"
@export var _weapon_type: String = "Ametralladora"
@export var _texture: Texture2D
@export var _sprite_texture: String = "res://assets/graphics/character_graphics/armas/arma1.png" # texto de la ubicacion exacta del sprite
@export var _cost: float = 1
@export var _shoot_time: float = 1
@export var _bullet_type: String = "A"

@export var _rarety: int = 0:   # comun = 0, rara = 1, épica = 2 y legendaria = 3
	set(value):
		_rarety = clamp(value, 0, 4)

# Señales
signal weapon_updated

# Métodos
func atack(amount: int) -> void:
	pass
	
func buy(amount: float) -> void:
	pass
func sell(amount: float) -> void:
	pass

# getters
func get_cost() -> float:
	return _cost
	
func get_rarety() -> float:
	return _rarety
