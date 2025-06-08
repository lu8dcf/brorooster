extends Item

class_name Arma

@export var arma_data: ArmaData

var puedoDisparar = true
var inv_image_weapon=0
var target_angle: float = 0.0
var diferencia_sprite_weapon := 0.0  # si querés ajustar el ángulo por sprite

var danio_base #cuando uso un multiplicador, debo hacerlo en base a este valor
var cadencia_base

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
	GlobalWeapon.weapon_updatedStats.connect(_on_actualizarArma) #conecto con una señal en globalWeapon, para actualizar estadisticas
	danio_base = arma_data.damage #agrego esta lineas para tener un margen
	cadencia_base =arma_data.tiempoDisparo #agrego esta lineas para tener un margen
	

func _process(delta):
	#cambio la rotacion del arma (tiene que se la instancia, la escena en ejecucion)
	rotation = lerp_angle(rotation, target_angle + diferencia_sprite_weapon, 14.0 * delta)
	
	# Determinar si el arma está apuntando hacia la izquierda invierte el sprite
	if  abs(target_angle) > PI/2 and inv_image_weapon == 0:
		$Sprite2D.flip_v = true # Voltear horizontalmente el sprite del arma
		inv_image_weapon=1
		
	elif abs(target_angle) < PI/2  and inv_image_weapon == 1:
		$Sprite2D.flip_v = false # dejarla original
		inv_image_weapon=0
	
	
func get_danio_total():
	return GlobalWeapon.get_danioGlobal() * arma_data.damage


#Metodos
func get_tiempoDisparo() -> float:
	return (arma_data.tiempoDisparo * GlobalWeapon.get_CadenciaGlobal())


func shoot(posicion: Vector2):  # Disparo hacia el angulo del enemigo mas cercano
	if (puedoDisparar == true):
		puedoDisparar = false
		if not arma_data:
			push_error("No hay datos del arma")
			return
			
		var bullet = arma_data.bullet_scene.instantiate()
		var direccion = Vector2.from_angle(target_angle)#Vector2.from_angle(direccionEnemigo) 
		bullet.setup(get_danio_total(), direccion)
		bullet.global_position = posicion
		bullet.rotation = target_angle
		get_tree().get_root().add_child(bullet)
		
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("retroceso")
		await get_tree().create_timer(get_tiempoDisparo()).timeout
		puedoDisparar = true

func _on_actualizarArma():
	if (danio_base != GlobalWeapon.get_danioGlobal()):
		arma_data.damage = danio_base * GlobalWeapon.get_danioGlobal()
	if ( cadencia_base != GlobalWeapon.get_CadenciaGlobal()):
		arma_data.tiempoDisparo = cadencia_base *GlobalWeapon.get_CadenciaGlobal()
	pass
