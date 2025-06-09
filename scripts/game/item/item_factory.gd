extends Node2D
# Diccionario de escenas de items precargadas
@onready var item_scenes = {
	1: preload("res://scenes/game/item/i_maiz_1.tscn"),
	2: preload("res://scenes/game/item/i_maiz_2.tscn"),
	3: preload("res://scenes/game/item/i_maiz_3.tscn"),
	4: preload("res://scenes/game/item/i_pu_Veloci.tscn"),
	5: preload("res://scenes/game/item/i_pu_Vida.tscn"),
	6: preload("res://scenes/game/item/i_pu_WeaponDanio.tscn"),
	7: preload("res://scenes/game/item/i_pu_WeaponVdisparo.tscn"),
	8: preload("res://scenes/game/item/i_Velociti.tscn"),
	9: preload("res://scenes/game/item/i_Vida.tscn"),
	10: preload("res://scenes/game/item/I_WeaponDanio.tscn"),
	11: preload("res://scenes/game/item/i_WeaponVdisparo.tscn")
}


# Función para crear un item en una posición específica

func spawn_item(item_type: int, position: Vector2) -> void:
	
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
