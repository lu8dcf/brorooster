extends CanvasLayer

@onready var button_sound: AudioStreamPlayer = $button_sound
@export var button_click_sound: AudioStream


@onready var weapon_portrait = $Sprite2D
@onready var weapon_label = $weapon_name

# Referencias a los indicadores
@onready var cost_indicator = $Panel/HBoxContainer/cost_indicator
@onready var damage_indicator = $Panel/HBoxContainer/damage_indicator
@onready var rarety_indicator = $Panel/HBoxContainer/rarety_indicator


# Añade estas constantes para comparación
const BASE_COST = 100
const BASE_DAMAGE = 1.0
const BASE_RARETY = 200 # CAMBIAR TODOS ESTOS VALORES
