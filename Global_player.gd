extends Resource
class_name CharacterData

# Propiedades exportadas para configurar en el editor
@export var _key: String = "default"
@export var _display_name: String = "Personaje"
@export var _texture: Texture2D
@export var _sprite_player: String
@export var _max_health: int = 100

@export var _health: int = _max_health:
	set(value):
		_health = clamp(value, 0, _max_health)
		emit_signal("health_changed", _health)
@export var _speed: int = 200:
	set(value):
		_speed = clamp(value, 0, 400)
@export var _armor: float = 1.0:
	set(value):
		_armor = clamp(value, 0.1, 1.0)
		
		


# Señales
signal health_changed(new_value: int)
signal character_updated

# Métodos
func take_damage(amount: int) -> void:
	_health = max(0, _health - amount)

func heal(amount: int) -> void:
	_health = min(100, _health + amount)


func get_sprite() -> Texture2D:
	return _texture
	
func get_texture_path() -> String:
	return _texture.resource_path if _texture else ""
	
func get_display_name() -> String:
	return _display_name
