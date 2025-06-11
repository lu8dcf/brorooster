extends CharacterBody2D
class_name Player

# Propiedades 
@export var health: int = 100 # vida del player
@export var speed: int = 200 # velocidad de movimiento del player
@export var armor: float = 1.0 # Armadura 1 sin armadura / 0.8 recibe 20% menos daño
@export var sprite_path: String

# Referencia al sprite para poder modificarlo mas adelante ne la seleccion del player
@onready var sprite = $Sprite2D 

# Constructor
func _init(initial_health: int = 100, initial_speed: int = 300, 
		  initial_armor: float = 0, sprite_node_path: String=("res://assets/graphics/character_graphics/gallos/gallo1.png")):
	health = initial_health
	speed = initial_speed
	armor = initial_armor
	sprite_path = sprite_node_path
	
# Función para cargar el player
func setup(new_health: int, new_speed: int, new_armor: float, new_sprite_path: NodePath):
	health = new_health
	speed = new_speed
	armor = new_armor
	sprite_path = new_sprite_path
	if sprite_path != "":
		$Sprite2D.texture = load(sprite_path)	# Cambia la textura de player dependiedno la seleccion
		# Añadir efectos como sombras
		#var shadow = Sprite2D.new()
		#shadow.texture = $Sprite2D.texture
		#shadow.modulate = Color(100, 0, 0, 0.3)
		#shadow.position = Vector2(5, 5)
		#shadow.z_index = $Sprite2D.z_index - 3
		#add_child(shadow)
	

var velocidad_extra = 5 # diferencia de velocidades entre caminar y volar

var fly_cooldown = 1  # Tiempo de vuelo
var can_fly = true # habilitacion para que vuele

var extra = 1 # variable de refuerzo cuando vuela toma el valor del multiplicador velocidad extra

var direction = Vector2.ZERO
var acceleration: float = 8.0  # Suavizado del movimiento
var rotation_speed: float = 5.0
var target_velocity: Vector2 = Vector2.ZERO
var mouse_sensitivy = Global.mouse_sens # se utiliza la variable global que se modifica en el menu de opciones

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var deadzone_radius : float = Global.deadzone_radius_main  # Zona muerta para cuando el mouse se alinea con el player

var move_right = "right"
var move_left = "left"

#Weapon
	#habilitar las armas    estas son las variables al seleccionar las armas
@export var arma1_data: ArmaData
@export var arma2_data: ArmaData



var diferencia_sprit_weapon = 0 # con el sprite a cero se puede evitar
var inv_image_weapon1=0 # determinacion hacia adonde aponta el arma de 0aPI/2 derecha =0
var inv_image_weapon2=0


@onready var weapon_anchor: Marker2D = $WeaponAnchor1 # punto de union del arma

#var arma1_scene : PackedScene
#var arma2_scene : PackedScene


var nuevaArma : ArmaData
var useSelector = false
var queArmaToca = 1

@onready var muzzle1  :  Marker2D = $shoot1 #desde donde sale el disparo
var shooting1 = false

	#weapon2
@onready var weapon2_anchor: Marker2D = $WeaponAnchor2 # punto d eunion del arma

	#disapro2
@onready var muzzle2  :  Marker2D = $shoot2
var shooting2 = false



#var new_weapon = null
var current_weapon1: Node2D 
var current_weapon2: Node2D 
var target_angle: float = 0.0 




func _ready():
	#Conecto al cambio de arma del global para detectar los cambios.
	Global.connect("weapon_changed", Callable(self ,"_on_weapon_changed"))
	if arma1_data and arma1_data.arma_escena and arma1_data:
		equip_weapon1()

		
func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	move_with_mouse()
	
func _process(delta):	
	# Rotar gradualmente el arma hacia el ángulo objetivo

	if is_instance_valid(current_weapon1): 
		#Aca le mando la direccion en la que debe rotar. Obtenido desde el main_game
		current_weapon1.target_angle = target_angle #para que el arma propia rote
			
	if is_instance_valid(current_weapon2):
		current_weapon2.target_angle = target_angle


func move_with_mouse():
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # oculta el mouse y evita que salga de la pantalla del videojuego
	var move_vector = Vector2.ZERO
	var mouse_position = get_viewport().get_mouse_position() #posicion del mouse
	var direction_to_mouse = (mouse_position - global_position) #la distancia entre el mouse y el player
	
	# Lógica de movimiento según la posición del mouse
	if direction_to_mouse.length() > deadzone_radius:
				
		if Input.is_action_just_pressed("ui_click_izq") and can_fly:  # volar con click
				
			# Temporizador para controlar duración del vuelo
			move_right = "fly_right"
			move_left = "fly_left"
			extra = velocidad_extra # Incrementar velocidad para el vuelo
			$rooster_cry.play()
			can_fly = false #no podra volver a volar hasta que termine el tiempo
			await get_tree().create_timer(fly_cooldown).timeout  # Tiempo de vuelo: 1 segundo
			can_fly = true
			move_right = "right"
			move_left = "left"
			extra = 1 # normaliozar el movimiento
				
			
		direction_to_mouse = direction_to_mouse.normalized() * extra * speed  * mouse_sensitivy  # Reduce la velocidad a la normal		
			
	else:
		# Si está en la zona muerta, detener movimiento y animación
		direction_to_mouse = Vector2.ZERO  # Si está en la zona muerta, no se mueve
		$AnimationPlayer.stop()
	
	if direction_to_mouse.x > 0:
		$AnimationPlayer.play(move_right)
	else:
		$AnimationPlayer.play(move_left)
			
	# Actualizar posición del gallo
	move_vector += direction_to_mouse
	
	# Interpolación para movimiento suave
	velocity = velocity.lerp(move_vector, acceleration * get_process_delta_time())
	move_and_slide()
	
	# equipa el arma 1

func equip_weapon1():
	if arma1_data and arma1_data.arma_escena:
		if is_instance_valid(current_weapon1):
			current_weapon1.queue_free()
	current_weapon1 = arma1_data.arma_escena.instantiate() #va a instanciar un arma
	if(!useSelector):
		current_weapon1.arma_data = Global.currentWeapon #Aca le asigna el current weapon del global
		useSelector = true
	else:
		current_weapon1.arma_data = nuevaArma
	weapon_anchor.add_child(current_weapon1)
	current_weapon1.position = Vector2.ZERO

	
	## Instancia la escena del arma
	

	
	#Agregar señal desde global que permita saber cuando equipar las segunda arma

func equip_weapon2():
	# Instancia la escena del arma
	current_weapon2 = arma2_data.arma_escena.instantiate()
	current_weapon2.arma_data = nuevaArma
	$WeaponAnchor2.add_child(current_weapon2)
	current_weapon2.position = Vector2.ZERO

	
func unequip_weapon1(): # desequipar le arma
	if is_instance_valid(current_weapon1):
		remove_child(current_weapon1)
		current_weapon1.queue_free()
		current_weapon1 = null
		#print("Arma desequipada.")
		
func unequip_weapon2(): # desequipar le arma
	if is_instance_valid(current_weapon2):
		remove_child(current_weapon2)
		current_weapon2.queue_free()
		current_weapon2 = null
	else:
		return
		#print("Arma desequipada.")




	
# Señal recibida desde main_game con el ángulo al enemigo más cercano
func _on_enemy_detected(angle_to_enemy: float):
	target_angle = angle_to_enemy
	shootWeapon1()
	shootWeapon2()
	
	
func shootWeapon1():
	if !shooting1 and current_weapon1:
		shooting1 = true
		current_weapon1.shoot(muzzle1.global_position)
		await get_tree().create_timer(arma1_data.tiempoDisparo).timeout
		shooting1 = false
	
func shootWeapon2():
	if !shooting2 and current_weapon2:
		shooting2 = true
		current_weapon2.shoot(muzzle2.global_position)
		await get_tree().create_timer(arma2_data.tiempoDisparo).timeout
		shooting2 = false
	


		


# recibir daño
func take_damage(amount: float):
	
	# $AnimationPlayer.play("hit")
	armor = Global.currentPlayer._armor
	var damage_taken = amount * armor
	Global.currentPlayer.take_damage(damage_taken)
	#print (Global.currentPlayer._health, "sacar: ", damage_taken, "armor,", armor)
	if Global.currentPlayer._health <= 0:
		die()

# morir al no tenes mas vida
func die():
	# $AnimationPlayer.play("death")
	# await $AnimationPlayer.animation_finished
	#queue_free()
	#print("mori")
	pass

# Juntar los items
func _on_area_recoleccion_area_entered(item) -> void:
	if item.is_in_group("items") and item.has_method("take_maiz"):
		item.take_maiz()  # recibir la cantidad de maiz

#Esto deberia permitirme reemplazar el arma, cuando haya cambios
func _on_weapon_changed(armaNueva :ArmaData):  #Esto es por señal, cuando en el global el arma cambia
	#que aca des equipo y vuelva a equipar la nueva.
	#Voy a probar lo siguiente. asigno el arma nueva al global.currentWeapon. ASi que la asigna de la manera que viene haciendo
	if queArmaToca % 2 == 0:
		# Cambiar arma 1
		if arma1_data == armaNueva:
			return
		unequip_weapon1()
		nuevaArma = armaNueva.duplicate()
		equip_weapon1()
	else:
		# Cambiar arma 2
		if arma2_data == nuevaArma:
			return
		unequip_weapon2()
		nuevaArma = armaNueva.duplicate()
		equip_weapon2()

	queArmaToca += 1
	
