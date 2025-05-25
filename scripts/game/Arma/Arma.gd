extends Item

class_name Arma

@export var arma_data: ArmaData
#
#Metodos


func get_tiempoDisparo() -> float:
	return (arma_data.tiempoDisparo)


func shoot(posicion: Vector2, direccionEnemigo : float):  # Disparo hacia el angulo del enemigo mas cercano
	if not arma_data:
		push_error("No hay datos del arma")
		return
		
	var shoot = arma_data.bullet_scene.instantiate()
	shoot.global_position = posicion
	shoot.rotation = direccionEnemigo # direccion del enemigo
	if shoot.has_method("set_direction"): # Método en la bala
		shoot.set_direction(Vector2.from_angle(direccionEnemigo))
	if shoot is bulletClass:
		shoot.damage = arma_data.damage

	get_tree().get_root().add_child(shoot)
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("retroceso")
	await get_tree().create_timer(arma_data.tiempoDisparo).timeout
	

func CombinarArma(condiciones):
	if(condiciones):
		print("Cumpli con las condiciones y retorno el path del obj")
	else:
		print("No es posoble combinar")
	pass
pass
