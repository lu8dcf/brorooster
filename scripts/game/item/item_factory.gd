extends Node2D
# Diccionario de escenas de items precargadas
@onready var item_scenes = {
	1: preload("res://scenes/game/item/maiz_1.tscn"),
	2: preload("res://scenes/game/item/maiz_2.tscn"),
	3: preload("res://scenes/game/item/maiz_3.tscn"),
	4: preload("res://scenes/game/item/maiz_1.tscn"),
	5: preload("res://scenes/game/item/maiz_1.tscn")
}


# Función para crear un item en una posición específica

func spawn_item(item_type: int, position: Vector2) -> void:
	print (item_type)
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
