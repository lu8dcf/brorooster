extends Control

var tiempo_restante = GlobalOleada.tiempo_seleccion



# Efectos para últimos 5 segundos
var is_shaking = false
var shake_intensity :float = 0.0
var original_position = Vector2.ZERO
var warning_played = false  # Para evitar repetir el sonido

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
var shop_items = []  # Almacenará las armas disponibles en la tienda
var selected_shop_item_index = -1  # Índice del item seleccionado en la tienda


#$ panel inventario
var selected_slot_index = -1  # -1 significa que no hay slot seleccionado

@onready var info_label = $panel_inventory/Label
# Referencias a los slots (asegúrate de que las rutas son correctas en tu escena)
@onready var slots = [ # slots inteario
	
	$panel_inventory/weapon_shadow,
	$panel_inventory/weapon_shadow2,
	$panel_inventory/weapon_shadow3,
	$panel_inventory/weapon_shadow4,
	$panel_inventory/weapon_shadow5,
	$panel_inventory/weapon_shadow6
	
]

@onready var slots_items=[ # slots de compra
	$panel_shop/weapon_shadow,
	$panel_shop/weapon_shadow2,
	$panel_shop/weapon_shadow3
]


@onready var slots_merge ={ # slots de combinacion
	"slot1" : $panel_merge/weapon_merge_1,
	"slot2" : $panel_merge/weapon_merge_2,
	"result" : $panel_merge/weapon_merge_result
}
var merge_weapons = []  # Almacenará las armas a combinar
var merged_result: ArmaData = null  # El resultado de la combinación


func _ready() -> void:
	
	get_tree().paused = false
	original_position = position
	
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
		
	if shop_items.is_empty():
		initialize_shop()
	for i in range(slots_items.size()):
		slots_items[i].pressed.connect(_on_shop_slot_pressed.bind(i))
		
	# Conectar señal del botón de resultado de fusión
		slots_merge["result"].pressed.connect(_on_merge_result_pressed)

	# Inicializar la tienda solo si está vacía (al inicio del juego)

		
	# Conectar señal del botón de vender
	$panel_inventory/btn_sold.pressed.connect(_on_vender_pressed)

	update_character()
	update_inventory()
	update_shop()
	update_merge()
	
func _process(delta):
	if is_shaking:
		shake_intensity = lerp(shake_intensity, 2.0, delta * 2)
		
		var offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		position = original_position + offset  # Usamos position
	else:
		position = position.lerp(original_position, delta * 10)  # Usamos position
	
func _on_timer_timeout():
	tiempo_restante -= 1
	GlobalOleada.tiempo_restante_seleccion = tiempo_restante
	GlobalOleada.time_changed.emit(tiempo_restante)
		
	if tiempo_restante <= 0:
		# Opcional: Detener el timer al llegar a 0
		tiempo_restante = GlobalOleada.tiempo_seleccion
		get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")	


func _on_time_shop_changed(new_time: int):
	temporizador.text = str(new_time) + " s"
	
	if new_time <= 12 and new_time > 0:
		if not warning_played:
			warning_played = true
			$Audio_shop.play()
	
	# Efectos para últimos 5 segundos
	if new_time <= 5 and new_time > 0:
		
		is_shaking = true
		temporizador.add_theme_color_override("font_color", Color.RED)
		
		var tween = create_tween()
		tween.tween_property(temporizador, "modulate:a", 0.5, 0.2)
		tween.tween_property(temporizador, "modulate:a", 1.0, 0.2)
		tween.set_loops(5)
	else:
		is_shaking = false
		shake_intensity = 0
		warning_played = false
		temporizador.remove_theme_color_override("font_color")
		temporizador.modulate.a = 1.0

func update_character():
	name_character.text = Global.currentPlayer.get_display_name()
	sprite_character.texture = Global.currentPlayer.get_sprite()
	maiz.text = str(GlobalOleada.maiz)
	
	
func update_inventory():
	var weapon_count = 0 #resetear contador
	
	for i in range(6):
		var item = Global.inventory_player[i]
		var slot = slots[i]
		# Asegúrate de que estos nodos existen en tu escena InventorySlot
		var portrait = slot.get_node("TextureRect") # o "Sprite2D" según tu escena
		if item is ArmaData:
			weapon_count +=1
			portrait.texture = item.sprite  # Usamos _texture que es el icono
			portrait.visible = true
		else:
			portrait.visible = false
			# Si el slot está vacío y estaba seleccionado, deseleccionarlo
			if selected_slot_index == i:
				_reset_slot_color(i)
				selected_slot_index = -1
	# Actualizar mensaje según cantidad de armas
	if weapon_count  <= 1:
		info_label.text = "Te queda solo un arma..."
	else:
		info_label.text = ""

	
	
# Función para inicializar la tienda (solo se llama al inicio)
func initialize_shop():
	shop_items = []
	for i in range(3):  # Máximo 3 items
		var arma_rara = GlobalWeapon.get_armaRara()
		shop_items.append(arma_rara)
	update_shop()
	
func update_shop():
	# Limpiar todos los slots primero
	for i in range(slots_items.size()):
		var slot = slots_items[i]
		var portrait = slot.get_node("TextureRect")
		var label = slot.get_node("text")
		var costo = slot.get_node("VBoxContainer/Label")
		
# Verificar si hay un item en esta posición
		if i < shop_items.size() and shop_items[i] != null:
			var item = shop_items[i]
			portrait.texture = item.sprite
			label.text = item.nombre
			costo.text = str(item.costo)
			portrait.visible = true
			
			# Mostrar en gris si no hay suficiente dinero
			if GlobalOleada.maiz < item.costo:
				slot.modulate = Color(0.5, 0.5, 0.5)
			else:
				slot.modulate = Color(1, 1, 1)
		else:
			# Slot vacío
			portrait.visible = false
			slot.modulate = Color(1, 1, 1)  # Resetear color


func _on_shop_slot_pressed(index: int):
	# Verificar que el índice es válido
	if index < 0 or index >= shop_items.size():
		return
	
	var item = shop_items[index]
	# Si el slot está vacío, no hacer nada
	if item == null:
		return
		
	# Verificar si es un ArmaData y si hay suficiente maíz
	if item is ArmaData and GlobalOleada.maiz >= item.costo:
		# Verificar si hay espacio en el inventario
		var empty_slot = Global.inventory_player.find(null)
		if empty_slot != -1:
			# Restar el costo
			GlobalOleada.maiz -= item.costo
			maiz.text = str(GlobalOleada.maiz)
			
			# Añadir al inventario
			Global.inventory_player[empty_slot] = item.duplicate()
			
			# Marcar el slot de la tienda como vacío (null) en lugar de eliminarlo
			shop_items[index] = null
			# Actualizar las visualizaciones
			update_inventory()
			update_shop()
			
			# Esperar un frame antes de verificar combinaciones
			await get_tree().process_frame            
			update_merge()
			
			# Debug: Verificar rareza
			print("Arma comprada - Rareza:", Global.inventory_player[empty_slot]._rarety)
			print("Arma en tienda - Rareza:", item._rarety if item else "N/A")
			# Sonido de compra exitosa
			$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/shop_buy.wav")
			$AudioStreamPlayer2D.play()
		else:
			info_label.text = "Inventario lleno!"
			$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/shop_cancel.mp3")
			$AudioStreamPlayer2D.play()
	elif item is ArmaData:
		info_label.text = "No tienes suficiente maíz!"
		$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/shop_cancel.mp3")
		$AudioStreamPlayer2D.play()


func update_merge():
	for slot in slots_merge.values():
		var portrait = slot.get_node("TextureRect")
		portrait.visible = false
	
	# Buscar armas para combinar
	find_mergeable_weapons()
	if merge_weapons.size() == 2:
		# Mostrar armas (solo visual, sin modificar)
		var portrait1 = slots_merge["slot1"].get_node("TextureRect")
		portrait1.texture = merge_weapons[0].sprite
		portrait1.visible = true
	
		var portrait2 = slots_merge["slot2"].get_node("TextureRect")
		portrait2.texture = merge_weapons[1].sprite
		portrait2.visible = true
		
		# Calcular resultado (creando nueva instancia)
		merged_result = GlobalWeapon.CombinarArma(merge_weapons[0].duplicate())  # Usar duplicate() para no modificar el original

		# Mostrar resultado
		var result_portrait = slots_merge["result"].get_node("TextureRect")
		result_portrait.texture = merged_result.sprite
		result_portrait.visible = true
	else:
		$panel_merge/Label3.text = "No hay armas para combinar"

func find_mergeable_weapons():
	merge_weapons.clear()
	
	# Usar diccionario para agrupar armas por nombre y rareza
	var weapon_groups = {}
	
	# Recorrer inventario sin modificar
	for i in range(Global.inventory_player.size()):
		var item = Global.inventory_player[i]
		if item is ArmaData:
			var key = item.nombre + "_" + str(item._rarety)  # Clave única por nombre y rareza
			if not weapon_groups.has(key):
				weapon_groups[key] = []
			weapon_groups[key].append(item)
	
	# Buscar grupos con exactamente 2 armas idénticas
	for key in weapon_groups:
		if weapon_groups[key].size() >= 2:
			# Tomar solo las primeras 2 armas del grupo
			merge_weapons = [weapon_groups[key][0], weapon_groups[key][1]]
			return

func _on_merge_result_pressed():
	if merge_weapons.size() != 2 or merged_result == null:
		return
	
	# Verificación adicional para asegurar que las armas aún existen
	var valid_weapons = 0
	for weapon in merge_weapons:
		if weapon in Global.inventory_player:
			valid_weapons += 1
	
	if valid_weapons != 2:
		print("Error: Las armas a combinar ya no están en el inventario")
		return
	
	# Eliminar las armas originales del inventario
	for i in range(Global.inventory_player.size()):
		if Global.inventory_player[i] in merge_weapons:
			Global.inventory_player[i] = null
	
	# Añadir el resultado al primer slot vacío
	var empty_slot = Global.inventory_player.find(null)
	if empty_slot != -1:
		Global.inventory_player[empty_slot] = merged_result
	
	# Actualizar todo
	merge_weapons.clear()
	merged_result = null
	update_inventory()
	update_merge()
	
	# Sonido de combinación exitosa
	#$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/merge_success.wav")
	#$AudioStreamPlayer2D.play()


func _on_slot_pressed(index: int):
	# Deseleccionar si ya está seleccionado
	if selected_slot_index == index:
		selected_slot_index = -1
		
		# Sonido de compra exitosa
		$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/shop_buy.wav")
		$AudioStreamPlayer2D.play()
			
			
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
	if item is ArmaData:
		var weapon_count = 0
		for weapon in Global.inventory_player:
			if weapon is ArmaData:
				weapon_count += 1
		if weapon_count > 1:
			# Añadir el valor de venta al maíz
			GlobalOleada.maiz += (item.costo+100)/2 # modificar ESTOO
			maiz.text = str(GlobalOleada.maiz)
			
			# Eliminar el objeto del inventario
			Global.inventory_player[selected_slot_index] = null
			$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/shop_sold.wav")
			$AudioStreamPlayer2D.play()
			
			# Actualizar la visualización del inventario
			update_inventory()
			update_merge()
			
			# Deseleccionar el slot
			_reset_slot_color(selected_slot_index)
			selected_slot_index = -1
		else:
			info_label.text = "Te queda solo un arma.."

func _highlight_slot(index: int):
	# Cambiar el color del botón seleccionado
	slots[index].modulate = Color(0.5, 1, 0.5)  # Color verde claro

func _reset_slot_color(index: int):
	# Restablecer el color original del botón
	slots[index].modulate = Color(1, 1, 1)  # Color original
