extends CanvasLayer

@onready var button_sound: AudioStreamPlayer = $button_sound
@export var button_click_sound: AudioStream

# Array de personajes precargados
@export var weapons: Array[ArmaData] = [
	preload("res://scripts/game/Arma/Armas/arma1.tres"),
	preload("res://scripts/game/Arma/Armas/melee1.tres"),
	preload("res://scripts/game/Arma/Armas/explosiva1.tres"),
	preload("res://scripts/game/Arma/Armas/arma2.tres"),
	preload("res://scripts/game/Arma/Armas/explosiva2.tres"),
	preload("res://scripts/game/Arma/Armas/melee2.tres"),
	preload("res://scripts/game/Arma/Armas/melee3.tres"),
	preload("res://scripts/game/Arma/Armas/melee4.tres"),
	preload("res://scripts/game/Arma/Armas/melee5.tres"),
	preload("res://scripts/game/Arma/Armas/explosiva3.tres"),
	preload("res://scripts/game/Arma/Armas/arma3.tres"),
	preload("res://scripts/game/Arma/Armas/melee6.tres"),
	preload("res://scripts/game/Arma/Armas/melee7.tres"),
	preload("res://scripts/game/Arma/Armas/arma4.tres"),
	preload("res://scripts/game/Arma/Armas/explosiva4.tres"),
	preload("res://scripts/game/Arma/Armas/melee8.tres"),
	] 

var random_weapons: Array[ArmaData] = [] # lista de las que se cargarán de forma aletoria


@onready var weapon_portrait =$Panel/Sprite2D
@onready var weapon_label = $Panel/weapon_name

# Referencias a los indicadores
@onready var cost_indicator = $Panel/HBoxContainer/cost_indicator
@onready var shoot_time_indicator = $Panel/HBoxContainer/shoot_time_indicator
@onready var bullet_type_indicator = $Panel/HBoxContainer/bullet_type_indicator



# Añade estas constantes para comparación
const BASE_COST = 100
const BASE_SHOOT_TIME = 1.0

# Cambia la constante BASE_BULLET_TYPE a un diccionario con texturas
@export var bullet_type_textures: Dictionary = {
	"A": preload("res://assets/graphics/menu_graphics/icon_menu/icon_bullet_a.png"),
	"B": preload("res://assets/graphics/menu_graphics/icon_menu/icon_bullet_b.png"),
	"C": preload("res://assets/graphics/menu_graphics/icon_menu/icon_sword.png")
}


var current_index: int = 0:
	set(value):
		current_index = value
		update_portrait(current_index)


func _ready() -> void:
	# Asegúrate de que el sonido está asignado
	if button_click_sound:
		button_sound.stream = button_click_sound
		
	# Añade este selector al grupo para que Global pueda encontrarlo
	add_to_group("weapon_selector")
	
	# Selecciona 3 armas aleatorias (sin repetición)
	random_weapons = select_random_weapons(3)
	
	
	# Configuración inicial
	if random_weapons.size() > 0:
		# Establece el primer arma como default si no hay una seleccionada
		if Global.currentWeapon == null:
			Global.currentWeapon = random_weapons[0]
		update_portrait(current_index)
		weapon_label.text = random_weapons[current_index].nombre
	else:
		push_error("No hay armas configuradas en el selector")
		
		# Configura los iconos base (hazlo solo una vez)
	cost_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_cost.png")
	shoot_time_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_speed.png")
	bullet_type_indicator.base_icon_texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_bullet_a.png")
	
	# Actualiza los indicadores con el personaje inicial
	update_attribute_indicators(random_weapons[current_index])

func select_random_weapons(count: int) -> Array[ArmaData]:
	var selected: Array[ArmaData] = []
	
	# Si hay menos armas que las solicitadas, devuelve todas
	if weapons.size() <= count:
		return weapons.duplicate()
	
	# Crea una copia del array para no modificar el original
	var available_weapons = weapons.duplicate()
	
	# Selecciona armas aleatorias sin repetir
	for i in range(count):
		if available_weapons.size() == 0:
			break
			
		var random_index = randi() % available_weapons.size()
		selected.append(available_weapons[random_index])
		available_weapons.remove_at(random_index)
	
	return selected


# En la función update_attribute_indicators, cambia la parte del tipo de bala:
func update_attribute_indicators(weapon: ArmaData) -> void:
	"""Actualiza los indicadores mostrando doble icono solo para valores dobles o mayores"""
	var cost_ratio = weapon.costo / float(BASE_COST)
	cost_indicator.set_modifier_weapon(
		1 if weapon.costo > BASE_COST else (-1 if weapon.costo < BASE_COST else 0),
		cost_ratio >= weapon.costo * 2  # Solo true si es doble o más
	)
	
	# Velocidad (solo mostrar doble si es ≥ 2x)
	var shoot_time_ratio = weapon.tiempoDisparo / BASE_SHOOT_TIME
	shoot_time_indicator.set_modifier_weapon(
		1 if weapon.tiempoDisparo < BASE_SHOOT_TIME else (-1 if weapon.tiempoDisparo > BASE_SHOOT_TIME else 0),
		shoot_time_ratio <= 0.5  # Solo true si es doble o más rápido
	)
	
	if bullet_type_textures.has(weapon._bullet_type):
		bullet_type_indicator.set_bullet_type(
			weapon._bullet_type,
			bullet_type_textures[weapon._bullet_type]
		)
	else:
		# Valor por defecto si el tipo no existe
		bullet_type_indicator.set_bullet_type("A", bullet_type_textures["A"])
	

func update_portrait(index: int) -> void:
	"""Actualiza el la imagen del arma """
	if index >= 0 and index < random_weapons.size():
		weapon_portrait.texture = random_weapons[index]._texture
		weapon_label.text = random_weapons[index].nombre  # Actualiza el label
		update_attribute_indicators(random_weapons[index])
	else:
		push_error("Índice de personaje fuera de rango")

func select_weapon() -> void:
	"""Selecciona el personaje actualmente visualizado"""
	if random_weapons.size() > 0 and current_index < random_weapons.size():
		Global.currentWeapon = random_weapons[current_index]
		print("arma seleccionada: ", Global.currentWeapon.nombre)
		
		# Opcional: Guardar selección para futuras sesiones
		save_selection()


func save_selection() -> void:
	"""Guarda la selección en ConfigFile para persistencia"""
	var config = ConfigFile.new()
	config.set_value("weapon", "selected_weapon", current_index)
	config.save("user://weapon_settings.cfg")

func load_selection() -> void:
	"""Carga la selección guardada"""
	var config = ConfigFile.new()
	var err = config.load("user://weapon_settings.cfg")
	if err == OK:
		current_index = config.get_value("weapon", "selected_weapon", 0)

# movimiento con teclas

# --- Control de navegación 
func _on_btn_lef_pressed() -> void:
	current_index = (current_index - 1) % random_weapons.size()
	if current_index < 0:
		current_index = random_weapons.size() - 1

func _on_btn_rig_pressed() -> void:
	current_index = (current_index + 1) % random_weapons.size()

# Función para reproducir sonido de botón
func _play_button_sound():
	if button_sound and button_sound.stream:
		button_sound.play()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_play_button_sound()
		select_weapon()
		GlobalHud.current_state =  GlobalHud.GameState.IN_GAME
		GlobalAudio.stop_music()
		get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/hud/character_selector.tscn")
		GlobalHud.current_state =  GlobalHud.GameState.CHARACTER_SELECT
	elif event.is_action_pressed("ui_right"):
		_play_button_sound()
		_on_btn_rig_pressed()
	elif event.is_action_pressed("ui_left"):
		_play_button_sound()
		_on_btn_lef_pressed()


func _on_btn_ok_pressed() -> void:
		select_weapon()
		GlobalHud.current_state =  GlobalHud.GameState.IN_GAME
		GlobalAudio.stop_music()
		get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")
