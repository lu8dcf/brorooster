extends Item

class_name Arma

@export var arma_data: ArmaData

var puedoDisparar = true
var inv_image_weapon1=0
var target_angle: float = 0.0
var diferencia_sprite_weapon := 0.0  # si querés ajustar el ángulo por sprite


#Constructor
func setup(nombre : String, sprite : Texture2D, damage : int, tiempoDisparo : float, bullet_scene : PackedScene, costo : int) -> void:
	arma_data = ArmaData.new()
	arma_data.nombre = nombre
	arma_data.sprite = sprite

	arma_data.damage = damage * GlobalWeapon.danio
	arma_data.tiempoDisparo = tiempoDisparo * GlobalWeapon.get_CadenciaGlobal()
	arma_data.bullet_scene = bullet_scene
	arma_data.costo = costo

func _ready() -> void:
	$Sprite2D.texture = arma_data.sprite
	set_danio_total()

func _process(delta):
	#cambio la rotacion del arma (tiene que se la instancia, la escena en ejecucion)
	rotation = lerp_angle(rotation, target_angle + diferencia_sprite_weapon, 14.0 * delta)
	
	# Determinar si el arma está apuntando hacia la izquierda invierte el sprite
	if  abs(target_angle) > PI/2 and inv_image_weapon1 == 0:
		$Sprite2D.flip_v = true # Voltear horizontalmente el sprite del arma
		inv_image_weapon1=1
		
	elif abs(target_angle) < PI/2  and inv_image_weapon1 == 1:
		$Sprite2D.flip_v = false # dejarla original
		inv_image_weapon1=0
	
	
func set_danio_total():
	return GlobalWeapon.get_danioGlobal() * arma_data.damage


#Metodos
func get_tiempoDisparo() -> float:
	return (arma_data.tiempoDisparo * GlobalWeapon.get_CadenciaGlobal())


func shoot(posicion: Vector2, direccionEnemigo : float):  # Disparo hacia el angulo del enemigo mas cercano
	if (puedoDisparar == true):
		puedoDisparar = false
		if not arma_data:
			push_error("No hay datos del arma")
			return
			
		var shoot = arma_data.bullet_scene.instantiate()
		shoot.global_position = posicion
		shoot.rotation = direccionEnemigo # direccion del enemigo
		
		var direccion = Vector2.from_angle(direccionEnemigo)
		
		if shoot.has_method("set_direction"): # Método en la bala
			shoot.setup(set_danio_total(), direccion)
			#shoot.set_direction(Vector2.from_angle(direccionEnemigo))

		get_tree().get_root().add_child(shoot)
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("retroceso")
		await get_tree().create_timer(get_tiempoDisparo()).timeout
		puedoDisparar = true
