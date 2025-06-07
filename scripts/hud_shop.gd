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

# Referencias a los slots (asegúrate de que las rutas son correctas en tu escena)
@onready var slots = [
	$panel_inventory/inv_1,
	$panel_inventory/inv_2,
	$panel_inventory/inv_3,
	$panel_inventory/inv_4,
	$panel_inventory/inv_5,
	$panel_inventory/inv_6
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
			portrait.texture = item.sprite  # Usamos _texture que es el icono
			portrait.visible = true
		else:
			portrait.visible = false

	
func update_shop():
	pass
	
func update_merge():
	pass
