extends CharacterBody2D

# Propiedades 
var speed = Global.speed_main # velocidad de movimiento del
var speed_fly = 2 # Velocidas de vuelo
var fly_cooldown = 1  # Tiempo de vuelo
var can_fly = true # habilitacion para que vuele
var extra = 2 # diferencia de velocidades

var direction = Vector2.ZERO
var acceleration: float = 8.0  # Suavizado del movimiento
var rotation_speed: float = 5.0
var target_velocity: Vector2 = Vector2.ZERO
# var deadzone_radius : float = GlobalSettings.deadzone_radius_main  # Zona muerta para cuando el mouse se alinea con la nave
var mouse_sensitivy = Global.mouse_sens # se utiliza la variable global que se modifica en el menu de opciones

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var deadzone_radius : float = Global.deadzone_radius_main  # Zona muerta para cuando el mouse se alinea con el player

var move_right = "right"
var move_left = "left"

#Weapon
@export var weapon_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@export var weapon2_scene: PackedScene # Exporta la escena del arma2 para poder asignarla desde el Inspector
@onready var weapon_anchor: Marker2D = $WeaponAnchor1 # punto d eunion del arma
@onready var weapon2_anchor: Marker2D = $WeaponAnchor2 # punto d eunion del arma
var new_weapon = null

var current_weapon: Node2D 
var current_weapon2: Node2D 
var arma_asignada=0
var target_angle: float = 0.0 

	#habilitar las armas
var weapon1 = true
var weapon2 = true


# Disparo
@export var shoot1_scene: PackedScene
@export var shoot2_scene: PackedScene
@onready var muzzle1  :  Marker2D = $shoot1
@onready var muzzle2  :  Marker2D = $shoot2
@onready var shoot_timer1 = $shoot_timer1
@onready var shoot_timer2 = $shoot_timer2

func _ready():
	if weapon_scene and weapon1: #si hay arma1, equipar
		equip_weapon(0.0)
		shoot_timer1.timeout.connect(_on_shoot_timer1_timeout)
		
	if weapon_scene and weapon1: #si hay arma2, equipar
		equip_weapon2(0.0)
		shoot_timer2.timeout.connect(_on_shoot_timer2_timeout)	
	
	
		
func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	move_with_mouse()
func _process(delta):
	# Rotar gradualmente el arma hacia el ángulo objetivo
	if is_instance_valid(current_weapon):
		current_weapon.rotation = lerp_angle(
			current_weapon.rotation,
			target_angle + 0.7854,
			10.0 * delta  # Ajusta la velocidad de rotación
		)
		
	if is_instance_valid(current_weapon2):
		current_weapon2.rotation = lerp_angle(
			current_weapon2.rotation,
			target_angle + 0.7854,
			10.0 * delta  # Ajusta la velocidad de rotación
		)
	
	
func move_with_mouse():
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # oculta el mouse y evita que salga de la pantalla del videojuego
	var move_vector = Vector2.ZERO
	var mouse_position = get_viewport().get_mouse_position() #posicion del mouse
	var direction_to_mouse = (mouse_position - global_position) #la distancia entre el mouse y el player
	#position.x = clamp (position.x,20, pantalla_ancho* .98) # Limite de movimientos en ancho de pantalla
	#position.y = clamp (position.y,10, pantalla_alto*0.95) # Limite de movimientos en altoo de pantalla

	# Lógica de movimiento según la posición del mouse
	if direction_to_mouse.length() > deadzone_radius:
				
		if Input.is_action_just_pressed("ui_click_izq") and can_fly:  # volar con click
				
			# Temporizador para controlar duración del vuelo
			move_right = "fly_right"
			move_left = "fly_left"
			extra = 5 # Incrementar velocidad para el vuelo
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
	
func equip_weapon(_angle:float):
	if not weapon_scene and not is_instance_valid(weapon_anchor):
		return
		
	if is_instance_valid(current_weapon):
		current_weapon.queue_free()
	# Instancia la escena del arma
	current_weapon = weapon_scene.instantiate()
	$WeaponAnchor1.add_child(current_weapon)
	current_weapon.position = Vector2.ZERO
	
	

func equip_weapon2(_angle:float):
	if not weapon2_scene and not is_instance_valid(weapon2_anchor):
		return
		
	if is_instance_valid(current_weapon2):
		current_weapon2.queue_free()
	# Instancia la escena del arma
	current_weapon2 = weapon2_scene.instantiate()
	$WeaponAnchor2.add_child(current_weapon2)
	current_weapon2.position = Vector2.ZERO
		
func unequip_weapon(): # desequipar le arma
	if is_instance_valid(current_weapon):
		remove_child(current_weapon)
		current_weapon.queue_free()
		current_weapon = null
		print("Arma desequipada.")

# cambio de armas
func change_weapon(new_weapon_scene: PackedScene):
	unequip_weapon()
	weapon_scene = new_weapon_scene
	equip_weapon(0.0)


func apuntar_arma(target_position: Vector2):
	
	#var direction_to_target = target_position - arma.global_position
	current_weapon.rotation = 1

	
# Señal recibida desde main_game con el ángulo al enemigo más cercano
func _on_enemy_detected(angle_to_enemy: float):
	target_angle = angle_to_enemy
	
func _on_shoot_timer1_timeout():
	shoot1(target_angle)
		
func _on_shoot_timer2_timeout():
	shoot2(target_angle)
		
func shoot1(angle):  # Disparo hacia el angulo del enemigo mas cercano
	var shoot1 = shoot1_scene.instantiate()
	shoot1.global_position = muzzle1.global_position
	shoot1.rotation = angle
	shoot1.set_direction(Vector2.from_angle(angle))  # Método en la bala
	get_parent().add_child(shoot1)
	
func shoot2(angle):  # Disparo hacia el angulo del enemigo mas cercano
	var shoot2 = shoot2_scene.instantiate()
	shoot2.global_position = muzzle2.global_position
	shoot2.rotation = angle
	shoot2.set_direction(Vector2.from_angle(angle))  # Método en la bala
	get_parent().add_child(shoot2)	
