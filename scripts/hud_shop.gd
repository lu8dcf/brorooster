extends Control

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
	update_character()
	update_inventory()
	update_shop()
	update_merge()

func _process(delta: float) -> void:
	temporizador.text = str(0)

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
