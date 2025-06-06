extends Control

# Referencias a los slots (asegúrate de que las rutas son correctas en tu escena)
@onready var slots = [
	$Slots/weapon_inv_1,
	$Slots/weapon_inv_2,
	$Slots/weapon_inv_3,
	$Slots/weapon_inv_4,
	$Slots/weapon_inv_5,
	$Slots/weapon_inv_6
]

func _ready():
	update_inventory()

func update_inventory():
	for i in range(6):
		var item = Global.inventory_player[i]
		var slot = slots[i]
		# Asegúrate de que estos nodos existen en tu escena InventorySlot
		var portrait = slot.get_node("TextureRect") # o "Sprite2D" según tu escena
		var number_label = slot.get_node("Label")
		if item is ArmaData:
			portrait.texture = item.sprite  # Usamos _texture que es el icono
			portrait.visible = true
			number_label.text = str(i + 1)
		else:
			portrait.visible = false
			number_label.text = str(i + 1)
