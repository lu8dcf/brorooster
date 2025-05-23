extends Control

@export var base_icon_texture: Texture2D
@export var modifier_icon_texture: Texture2D
@export var show_value: bool = false
@export var value_text: String = ""

@onready var base_icon = $HBoxContainer/icon_base
@onready var modifier_icon1 = $icon_modificator
@onready var modifier_icon2 = $icon_modificator2  # Nuevo nodo para segundo icono

func _ready():
	base_icon.texture = base_icon_texture
	modifier_icon1.texture = modifier_icon_texture
	modifier_icon2.texture = modifier_icon_texture
	modifier_icon2.hide()  # Ocultar por defecto

func set_modifier(comparison: int, is_double: bool = false):
	# Resetear todos los iconos primero
	modifier_icon1.hide()
	modifier_icon2.hide()
	
	match comparison:
		1:
			modifier_icon1.texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_up.png")
			modifier_icon1.show()
			if is_double:
				modifier_icon2.texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_up.png")
				modifier_icon2.show()
		0:
			# No hacer nada, ya están ocultos
			pass
		-1:
			modifier_icon1.texture = preload("res://assets/graphics/menu_graphics/icon_menu/icon_down.png")
			modifier_icon1.show()
			# Solo mostramos el segundo icono para valores positivos extremos (no para la mitad)
