extends CanvasLayer

# Array de personajes precargados
@export var characters: Array[CharacterData] = [
	preload("res://scripts/game/player/characters/pollo1.tres"),
	preload("res://scripts/game/player/characters/pollo2.tres"),
	preload("res://scripts/game/player/characters/pollo3.tres"),
	preload("res://scripts/game/player/characters/pollo4.tres")
]

@onready var char_portrait = $Sprite2D
@onready var name_label = $character_name

# Referencias a los indicadores
@onready var health_indicator = $HBoxContainer/health_indicator
@onready var armor_indicator = $HBoxContainer/armor_indicator
@onready var speed_indicator = $HBoxContainer/speed_indicator

# Añade estas constantes para comparación
const BASE_HEALTH = 100
const BASE_ARMOR = 1.0
const BASE_SPEED = 200

var current_index: int = 0:
	set(value):
		current_index = value
		update_portrait(current_index)


func _ready() -> void:
	# Añade este selector al grupo para que Global pueda encontrarlo
	add_to_group("character_selector")
	# Configuración inicial
	if characters.size() > 0:
		# Establece el primer personaje como default si no hay uno seleccionado
		if Global.currentPlayer == null:
			Global.currentPlayer = characters[0]
		update_portrait(current_index)
		name_label.text = characters[current_index]._display_name  # Actualiza el label
	else:
		push_error("No hay personajes configurados en el selector")
		
		# Configura los iconos base (hazlo solo una vez)
	health_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_heart.png")
	armor_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_armor.png")
	speed_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_speed.png")
	
	# Actualiza los indicadores con el personaje inicial
	update_attribute_indicators(characters[current_index])
	
	
func update_attribute_indicators(character: CharacterData) -> void:
	"""Actualiza los indicadores mostrando doble icono solo para valores dobles o mayores"""
	# Vida (solo mostrar doble si es ≥ 2x)
	var health_ratio = character._health / float(BASE_HEALTH)
	health_indicator.set_modifier(
		1 if character._health > BASE_HEALTH else (-1 if character._health < BASE_HEALTH else 0),
		health_ratio >= 2.0  # Solo true si es doble o más
	)
	
	# Armadura (solo mostrar doble si es ≥ 2x)
	var armor_ratio = character._armor / BASE_ARMOR
	armor_indicator.set_modifier(
		1 if character._armor > BASE_ARMOR else (-1 if character._armor < BASE_ARMOR else 0),
		armor_ratio >= 2.0  # Solo true si es doble o más
	)
	
	# Velocidad (solo mostrar doble si es ≥ 2x)
	var speed_ratio = character._speed / float(BASE_SPEED)
	speed_indicator.set_modifier(
		1 if character._speed > BASE_SPEED else (-1 if character._speed < BASE_SPEED else 0),
		speed_ratio >= 2.0  # Solo true si es doble o más
	)

	
func set_default_character() -> void:
	"""Establece el primer personaje como predeterminado globalmente"""
	if characters.size() > 0:
		Global.currentPlayer = characters[0]
		print("Personaje por defecto establecido: ", Global.currentPlayer._display_name)

func update_portrait(index: int) -> void:
	"""Actualiza el retrato del personaje mostrado"""
	if index >= 0 and index < characters.size():
		char_portrait.texture = characters[index]._texture
		name_label.text = characters[index]._display_name  # Actualiza el label
		update_attribute_indicators(characters[index])
	else:
		push_error("Índice de personaje fuera de rango")

func select_character() -> void:
	"""Selecciona el personaje actualmente visualizado"""
	if characters.size() > 0 and current_index < characters.size():
		Global.currentPlayer = characters[current_index]
		print("Personaje seleccionado: ", Global.currentPlayer._display_name)
		
		# Opcional: Guardar selección para futuras sesiones
		save_selection()

func save_selection() -> void:
	"""Guarda la selección en ConfigFile para persistencia"""
	var config = ConfigFile.new()
	config.set_value("player", "selected_character", current_index)
	config.save("user://player_settings.cfg")

func load_selection() -> void:
	"""Carga la selección guardada"""
	var config = ConfigFile.new()
	var err = config.load("user://player_settings.cfg")
	if err == OK:
		current_index = config.get_value("player", "selected_character", 0)

# --- Control de navegación 
func _on_btn_lef_pressed() -> void:
	current_index = (current_index - 1) % characters.size()
	if current_index < 0:
		current_index = characters.size() - 1

func _on_btn_rig_pressed() -> void:
	current_index = (current_index + 1) % characters.size()

func _on_btn_ok_pressed() -> void:
	select_character()
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_btn_ok_pressed()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/Main_menu.tscn")
	elif event.is_action_pressed("ui_right"):
		_on_btn_rig_pressed()
	elif event.is_action_pressed("ui_left"):
		_on_btn_lef_pressed()
