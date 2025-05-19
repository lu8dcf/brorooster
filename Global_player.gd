extends Resource
class_name CharacterData


@export var Key: String
@export var Imagen: Texture2D
@export var name :String
@export var health: int
@export var speed:int
@export var armor: float



var selected_character = 0

const characters = [
	preload("res://assets/graphics/character_graphics/character_menu/gallina1.png"),
	preload("res://assets/graphics/character_graphics/character_menu/gallina2.png"),
	preload("res://assets/graphics/character_graphics/character_menu/gallina3.png")
] # poner mas cantidad de perspreload("res://assets/graphics/character_graphics/character_menu/gallina3.png"),onajes, esto garantiza que el programa ya posea las img 
