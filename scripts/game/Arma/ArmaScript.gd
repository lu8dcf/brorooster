extends Item

class_name Arma

@export var arma_data: ArmaData
#
#Constructor
func setup(nombre : String, sprite : Texture2D, damage : int, tiempoDisparo : float, bullet_scene : PackedScene, costo : int) -> void:
	arma_data = ArmaData.new()
	arma_data.nombre = nombre
	arma_data.sprite = sprite
	arma_data.damage = damage
	arma_data.tiempoDisparo = tiempoDisparo
	arma_data.bullet_scene = bullet_scene
	arma_data.costo = costo



#y para instanciar, seria:
#var nueva_arma = Arma.new()
#nueva_arma.setup("pistola2", arma4, 30, 0.1, preload("res://....tscn"), 100)


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
	
	var direccion = Vector2.from_angle(direccionEnemigo)
	
	if shoot.has_method("set_direction"): # Método en la bala
		shoot.setup(arma_data.damage, direccion)
		#shoot.set_direction(Vector2.from_angle(direccionEnemigo))

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
