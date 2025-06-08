extends Node2D
# Diccionario de escenas de items precargadas
@onready var item_scenes = {
	1: preload("res://Items/Maiz.tscn"),
	2: preload("res://Items/PVida.tscn"),
	3: preload("res://Items/PVelocidad.tscn"),
	4: preload("res://Items/PVelocidadDisparo.tscn"),
	5: preload("res://Items/PDanioArma.tscn")
}

# Función para crear un item en una posición específica
func spawn_item(item_type: int, position: Vector2) -> void:
	if item_type > 0 and item_type in item_scenes:
		var item = item_scenes[item_type].instantiate()
		get_tree().current_scene.add_child(item)
		item.global_position = position

# Ejemplo de mejora con efectos (añadir a ItemFactory.gd)
func spawn_item2(item_type: int, position: Vector2) -> void:
	if item_type > 0 and item_type in item_scenes:
		var item = item_scenes[item_type].instantiate()
		get_tree().current_scene.add_child(item)
		item.global_position = position
		
		# Efecto visual al aparecer
		var tween = create_tween()
		item.scale = Vector2(0.5, 0.5)
		tween.tween_property(item, "scale", Vector2(1, 1), 0.3)\
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		
		# Efecto de flotación
		var float_tween = create_tween()
		float_tween.tween_property(item, "position:y", position.y - 10, 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		float_tween.tween_property(item, "position:y", position.y, 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		float_tween.set_loops()
