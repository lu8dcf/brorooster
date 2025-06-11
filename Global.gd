extends Node

signal lives_changed(new_value)

#inventario global
var inventory_player = [null, null, null, null, null, null] # inventario de maximo 6 slots
var manos = [null,null]

# Referencia al personaje actual
var currentPlayer: CharacterData = null:
	set(value):
		if value is CharacterData:
			currentPlayer = value
			# Conecta señales del personaje
			if currentPlayer.health_changed.is_connected(_on_character_health_changed):
				currentPlayer.health_changed.disconnect(_on_character_health_changed)
			currentPlayer.health_changed.connect(_on_character_health_changed)
			character_changed.emit(currentPlayer)
		else:
			push_error("Se intentó asignar un tipo inválido a currentPlayer")


var currentWeapon: ArmaData = null:
	set(value):
		if value is ArmaData:
			currentWeapon = value
			# Conecta señales del personaje
			weapon_changed.emit(currentWeapon)
			inventory_player[0] = currentWeapon
		else:
			push_error("Se intentó asignar un tipo inválido a currentWeapon")

func change_currentWeapon(arma :ArmaData): #Llamar a este desde inventario
	weapon_changed.emit(arma)
	



#var secondaryWeapon: ArmaData = null:
	#set(value):
		#if value is ArmaData:
			#secondaryWeapon = value
			## Conecta señales del personaje
			#weapon_changed_secondary.emit(secondaryWeapon)
			#inventory_player[1] = secondaryWeapon
		#else:
			#push_error("Se intentó asignar un tipo inválido a currentWeapon")


func _ready() -> void:
	# Inicializar con personaje por defecto
	if currentPlayer == null:
		initialize_default_character()
	if currentWeapon == null:
		initialize_default_weapon()
		
# Señales globales
signal character_changed(new_character: CharacterData)
signal weapon_changed(new_weapon: ArmaData)
signal health_changed(new_value: int)

# Otras propiedades globales
var mouse_sens := 0.5
var speed_main := 200
var deadzone_radius_main := 20 
var score := 0
var enemigos_eliminados := 0
var pantalla_ancho := 1152
var pantalla_alto := 648
var angle := 0
# var stage := 1   # se debe dejar de usar serian oleadas


# Métodos de conveniencia para acceder a propiedades
func get_health() -> int:
	return currentPlayer._health if currentPlayer else 0

func get_speed() -> int:
	return currentPlayer._speed if currentPlayer else 200

func get_armor() -> float:
	return currentPlayer._armor if currentPlayer else 1.0

func get_sprite() -> float:
	return currentPlayer._sprite if currentPlayer else "res://assets/graphics/character_graphics/gallo.png"
	
func get_currentWeapon() -> ArmaData:
	return currentWeapon
	
	
func initialize_default_character() -> void:
	# Carga el primer personaje del selector si existe
		var selector = get_tree().get_first_node_in_group("character_selector")
		if selector and selector.characters.size() > 0:
			currentPlayer = selector.characters[0]
		else:
		# Fallback: crea un personaje por defecto
			var default_char = CharacterData.new()
			default_char._key = "gallo"
			default_char._display_name = "Gallo"
			default_char._health = 100
			default_char._speed = 200
			default_char._armor = 1.0
			default_char._texture = preload("res://assets/graphics/character_graphics/character_menu/gallina1.png")
			default_char._sprite_player = "res://assets/graphics/character_graphics/gallo.png"
			currentPlayer = default_char
			push_warning("Usando personaje por defecto fallback")
			

func initialize_default_weapon() -> void:
	# Carga el primer personaje del selector si existe
		var selector = get_tree().get_first_node_in_group("weapon_selector")
		if selector and selector.characters.size() > 0:
			currentWeapon = selector.characters[0]
		else:
		# Fallback: crea un personaje por defecto
			var default_weapon = ArmaData.new()
			#default_weapon._id = 0
			default_weapon._bullet_type="A"
			default_weapon.costo = 1
			default_weapon.nombre = "Arma"
			default_weapon._rarety = 0
			default_weapon.arma_escena = preload("res://scenes/game/Armas/Arma.tscn") # agregue esta linea
			default_weapon.bullet_scene = preload("res://scenes/game/Bullet/bullet.tscn")
			default_weapon._texture = preload("res://assets/graphics/character_graphics/weapon_menu/Iconodearma1.png")
			default_weapon.sprite= preload("res://assets/graphics/character_graphics/armas/armas_con_sus_niveles/arma1_nivel1.png")
			currentWeapon = default_weapon
			push_warning("Usando arma por defecto fallback")

# Global.current_weapon.

func _on_character_health_changed(new_health: int):
	# Propaga el cambio de salud del personaje como señal global
	lives_changed.emit(new_health)
