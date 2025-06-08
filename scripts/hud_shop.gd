extends Control

var tiempo_restante = GlobalOleada.tiempo_seleccion


@onready var panel_character = $panel_character
@onready var panel_inventory = $panel_inventory
@onready var panel_shop = $panel_shop
@onready var panel_merge = $panel_merge

#panel jugador
@onready var name_character = $panel_character/Label
@onready var sprite_character = $panel_character/character
#var global oleada maiz
@onready var maiz = $panel_character/VBoxContainer/maiz

#panel compras
@onready var temporizador = $panel_shop/temporizador

#$ panel inventario
var selected_slot_index = -1  # -1 significa que no hay slot seleccionado
var cant_weapon = 0

@onready var info_label = $panel_inventory/Label
# Referencias a los slots (asegúrate de que las rutas son correctas en tu escena)
@onready var slots = [
	
	$panel_inventory/weapon_shadow,
	$panel_inventory/weapon_shadow2,
	$panel_inventory/weapon_shadow3,
	$panel_inventory/weapon_shadow4,
	$panel_inventory/weapon_shadow5,
	$panel_inventory/weapon_shadow6
	
]


func _ready() -> void:
	
	get_tree().paused = false
	
	
	# Configura un Timer para decrementar cada segundo
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(1.0)  # Intervalo de 1 segundo
	
	temporizador.text = str(GlobalOleada.tiempo_restante_seleccion)
	
	GlobalOleada.time_changed.connect(_on_time_shop_changed)  # Conecta la señal
	
	
	# Conectar señales de los slots
	for i in range(slots.size()):
		slots[i].pressed.connect(_on_slot_pressed.bind(i))

	# Conectar señal del botón de vender
	$panel_inventory/btn_sold.pressed.connect(_on_vender_pressed)

	update_character()
	update_inventory()
	update_shop()
	update_merge()
	
func _on_timer_timeout():
	tiempo_restante -= 1
	GlobalOleada.tiempo_restante_seleccion = tiempo_restante
	GlobalOleada.time_changed.emit(tiempo_restante)
	print (tiempo_restante)
		
	if tiempo_restante <= 0:
		# Opcional: Detener el timer al llegar a 0
		tiempo_restante = GlobalOleada.tiempo_seleccion
		get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")	


func _on_time_shop_changed(new_time: int):
	# Propaga el cambio de salud del personaje como señal global
	temporizador.text = str(new_time) + " s"

func update_character():
	name_character.text = Global.currentPlayer.get_display_name()
	sprite_character.texture = Global.currentPlayer.get_sprite()
	maiz.text = str(GlobalOleada.maiz)
	
	
func update_inventory():
	
	
	for i in range(6):
		var item = Global.inventory_player[i]
		var slot = slots[i]
		# Asegúrate de que estos nodos existen en tu escena InventorySlot
		var portrait = slot.get_node("TextureRect") # o "Sprite2D" según tu escena
		if item is ArmaData:
			cant_weapon+=1
			portrait.texture = item.sprite  # Usamos _texture que es el icono
			portrait.visible = true
		else:
			portrait.visible = false
			# Si el slot está vacío y estaba seleccionado, deseleccionarlo
			if selected_slot_index == i:
				_reset_slot_color(i)
				selected_slot_index = -1

	
func update_shop():
	pass
	
func update_merge():
	pass
	
	
func _on_slot_pressed(index: int):
	# Deseleccionar si ya está seleccionado
	if selected_slot_index == index:
		selected_slot_index = -1
		# Restablecer el color del slot (implementa esta función según tu UI)
		_reset_slot_color(index)
	else:
		# Deseleccionar el slot anterior si hay uno
		if selected_slot_index != -1:
			_reset_slot_color(selected_slot_index)
		
		# Seleccionar el nuevo slot
		selected_slot_index = index
		# Cambiar el color del slot seleccionado (implementa esta función)
		_highlight_slot(index)

func _on_vender_pressed():
	if selected_slot_index == -1:
		return  # No hay nada seleccionado
	
	var item = Global.inventory_player[selected_slot_index]
	if item is ArmaData and cant_weapon>1:
		# Añadir el valor de venta al maíz
		GlobalOleada.maiz += (item.costo+100)/2 # modificar ESTOO
		maiz.text = str(GlobalOleada.maiz)
		
		# Eliminar el objeto del inventario
		Global.inventory_player[selected_slot_index] = null
		
		# Actualizar la visualización del inventario
		update_inventory()
		
		# Deseleccionar el slot
		_reset_slot_color(selected_slot_index)
		selected_slot_index = -1
	info_label.text = "Te queda solo un arma.."

func _highlight_slot(index: int):
	# Cambiar el color del botón seleccionado
	slots[index].modulate = Color(0.5, 1, 0.5)  # Color verde claro

func _reset_slot_color(index: int):
	# Restablecer el color original del botón
	slots[index].modulate = Color(1, 1, 1)  # Color blanco (original)
