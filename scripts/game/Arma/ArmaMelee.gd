extends Arma

var atacar = false



var estoyAtacando = false;

func _ready() -> void:
	var collision = $CollisionShape2D

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
	
	atacar = true
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(arma_data.tiempoDisparo).timeout
	atacar = false
	$CollisionShape2D.disabled = true
	pass


#
#func set_direction(dir: Vector2): # Direccion de la bala
	#direction = dir

#Metodo
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (atacar):
		if body.is_in_group("enemies") and body.has_method("take_damage") and !estoyAtacando:
			estoyAtacando = true
			$AnimationPlayer.play("retroceso")
			body.take_damage(arma_data.damage)
			await get_tree().create_timer(.1).timeout
			estoyAtacando = false
pass # Replace with function body.
