extends Control

@onready var weapon_portrait =$Slots/weapon_inv_1/Sprite2D2
@onready var weapon_text =$Slots/weapon_inv_1/Label


var inventory = Global.inventory_player
var weaponActual = inventory[0]

func _ready() -> void:
	
	updateInventory()
	
	

func  updateInventory():
	
	weapon_portrait.texture = weaponActual.sprite
	weapon_text.text = "1"
	
