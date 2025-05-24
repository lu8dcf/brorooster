extends Resource
class_name WeaponData

# Propiedades exportadas para configurar en el editor
@export var _key: String = "default"
@export var _display_name: String = "Arma"
@export var _texture: Texture2D
#@export var _sprite_player: String
@export var _cost: float = 1
@export var _rarety: int = 1
@export var _damage: float = 1


@export var _speed: int = 200:
	set(value):
		_speed = clamp(value, 0, 400)
@export var _armor: float = 1.0:
	set(value):
		_armor = clamp(value, 0.1, 1.0)

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
