extends Control

@export var base_icon_texture: Texture2D
@export var modifier_icon_texture: Texture2D
@export var show_value: bool = false
@export var value_text: String = ""

@onready var base_icon = $HBoxContainer/icon_base
@onready var modifier_icon = $icon_modificator

func _ready():
	base_icon.texture = base_icon_texture
	modifier_icon.texture = modifier_icon_texture


func set_modifier(comparison: int): # 1: mayor, 0: igual, -1: menor
	match comparison:
		1:
			modifier_icon.texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_up.png")
			modifier_icon.show()
		0:
			modifier_icon.hide()
		-1:
			modifier_icon.texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_down.png")
			modifier_icon.show()
