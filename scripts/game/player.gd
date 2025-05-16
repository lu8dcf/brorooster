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
	#habilitar las armas
var weapon1_enable = true
var weapon2_enable = true

var weapon1_path= "res://scenes/game/weapon.tscn"
var weapon2_path= "res://scenes/game/weapon.tscn"

	#weapon1
@export var weapon1_scene_path: String = weapon1_path
var weapon1_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@onready var weapon_anchor: Marker2D = $WeaponAnchor1 # punto de union del arma

	#disparo 1
@export var shoot1_scene: PackedScene
@onready var muzzle1  :  Marker2D = $shoot1 #desde donde sale el disparo
@onready var shoot_timer1 = $shoot_timer1 

	#weapon2
@export var weapon2_scene_path: String = weapon2_path
var weapon2_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@onready var weapon2_anchor: Marker2D = $WeaponAnchor2 # punto d eunion del arma

	#disapro2
@export var shoot2_scene: PackedScene
@onready var muzzle2  :  Marker2D = $shoot2
@onready var shoot_timer2 = $shoot_timer2	



var new_weapon = null

var current_weapon: Node2D 
var current_weapon2: Node2D 

var target_angle: float = 0.0 




func _ready():
	# Instalar el Weapon1 
	if weapon1_scene_path != "" and weapon1_enable:
		weapon1_scene = ResourceLoader.load(weapon1_scene_path)
		if weapon1_scene:
			var weapon1_instance = weapon1_scene.instantiate()
			add_child(weapon1_instance)
			equip_weapon1(0.0) # La coloca en la posicion 1
			shoot_timer1.timeout.connect(_on_shoot_timer1_timeout) # Activa el timer de disparo
		
	# Instalar el Weapon2 	
	if weapon2_scene_path != "" and weapon2_enable:
		weapon2_scene = ResourceLoader.load(weapon2_scene_path)
		if weapon2_scene:
			var weapon2_instance = weapon2_scene.instantiate()
			add_child(weapon2_instance)
			equip_weapon2(0.0) # La coloca en la posicion 1
			shoot_timer2.timeout.connect(_on_shoot_timer2_timeout) # Activa el timer de disparo
	
	
		
func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	move_with_mouse()
func _process(delta):
	# Rotar gradualmente el arma hacia el ángulo objetivo
	if is_instance_valid(current_weapon):
		current_weapon.rotation = lerp_angle(
			current_weapon.rotation,
			target_angle + 0.79,
			10.0 * delta  # Ajusta la velocidad de rotación
		)
		
	if is_instance_valid(current_weapon2):
		current_weapon2.rotation = lerp_angle(
			current_weapon2.rotation,
			target_angle + 0.78,
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
	
func equip_weapon1(_angle:float):
	if not weapon1_scene and not is_instance_valid(weapon_anchor):
		return
	
	if is_instance_valid(current_weapon):
		current_weapon.queue_free()
	# Instancia la escena del arma
	current_weapon = weapon1_scene.instantiate()
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
		
func unequip_weapon1(): # desequipar le arma
	if is_instance_valid(current_weapon):
		remove_child(current_weapon)
		current_weapon.queue_free()
		current_weapon = null
		print("Arma desequipada.")

# cambio de armas
func change_weapon(new_weapon_scene: PackedScene):
	unequip_weapon1()
	weapon1_scene = new_weapon_scene
	equip_weapon1(0.0)


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
