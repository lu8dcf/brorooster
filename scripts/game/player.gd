extends CharacterBody2D
class_name Player

# Propiedades 
@export var health: int = 100 # vida del player
@export var speed: int = 200 # velocidad de movimiento del player
@export var armor: float = 1.0 # Armadura 1 sin armadura / 0.8 recibe 20% menos daño
@export var sprite_path: String

# Referencia al sprite
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
		$Sprite2D.texture = load(sprite_path)	
	
	

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


var weapon1_enable = true
#var weapon1_path= "res://scenes/game/weapon.tscn"
var weapon1_path= "res://scenes/game/Armas/Arma.tscn"
#var shoot1_path="res://scenes/game/laser.tscn"
var shoot1_path="res://scenes/game/Bullet/bullet.tscn"
#var shoot1_path="res://scenes/game/Bullet/explosiveBullet.tscn"
var time_shoot1= 0.5
var shooting = false

var weapon2_enable = true
var weapon2_path= "res://scenes/game/weapon.tscn"
var shoot2_path="res://scenes/game/laser.tscn"
var time_shoot2= 0.3

var diferencia_sprit_weapon = 0 # con el sprite a cero se puede evitar
var inv_image_weapon1=0 # determinacion hacia adonde aponta el arma de 0aPI/2 derecha =0
var inv_image_weapon2=0

@export var weapon: Node2D  # Asigna el nodo del arma en el inspector
	#weapon1
@export var weapon1_scene_path: String = weapon1_path
var weapon1_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@onready var weapon_anchor: Marker2D = $WeaponAnchor1 # punto de union del arma

var arma1_scene : PackedScene

	#disparo 1
#@export var shoot1_scene_path: String = shoot1_path
#var shoot1_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector

@onready var muzzle1  :  Marker2D = $shoot1 #desde donde sale el disparo


	#weapon2
@export var weapon2_scene_path: String = weapon2_path
var weapon2_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@onready var weapon2_anchor: Marker2D = $WeaponAnchor2 # punto d eunion del arma

	#disapro2
@export var shoot2_scene_path: String = shoot2_path
var shoot2_scene: PackedScene # Exporta la escena del arma para poder asignarla desde el Inspector
@onready var muzzle2  :  Marker2D = $shoot2




#var new_weapon = null
var current_weapon1: Node2D 
var current_weapon2: Node2D 

var target_angle: float = 0.0 




func _ready():
	
	if arma1_data and arma1_data.arma_escena and arma1_data:
		arma1_scene = arma1_data.arma_escena
		equip_weapon1(0.0)
	# Instalar el Weapon1 
	if weapon1_scene_path != "" and weapon1_enable:
		weapon1_scene = ResourceLoader.load(weapon1_scene_path)
		if weapon1_scene:
			#var weapon1_instance = weapon1_scene.instantiate()
			#add_child(weapon1_instance)
			equip_weapon1(0.0) # La coloca en la posicion 1
		#	shoot1_scene = ResourceLoader.load(shoot1_scene_path)
			#if shoot1_scene:
				#timer_Shoot1() # Activa el timer de disparo
		
	# Instalar el Weapon2 	
	if weapon2_scene_path != "" and weapon2_enable:
		weapon2_scene = ResourceLoader.load(weapon2_scene_path)
		if weapon2_scene:
			var weapon2_instance = weapon2_scene.instantiate()
			#add_child(weapon2_instance)
			equip_weapon2(0.0) # La coloca en la posicion 1
			shoot2_scene = ResourceLoader.load(shoot2_scene_path)
			if shoot2_scene:
				timer_Shoot2() # Activa el timer de disparo
	
	
		
func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	move_with_mouse()
	
func _process(delta):
	# Rotar gradualmente el arma hacia el ángulo objetivo

	if is_instance_valid(current_weapon1): 
		
		var weapon_sprite = current_weapon1.get_node("Sprite2D")  # Sprite del arma
		#current_weapon1.rotation = lerp_angle(current_weapon1.rotation,prueba            , 10.0 * delta) 
		current_weapon1.rotation = lerp_angle(current_weapon1.rotation,target_angle + diferencia_sprit_weapon , 10.0 * delta)  # Ajusta la velocidad de rotación
		
		# Determinar si el arma está apuntando hacia la izquierda invierte el sprite
		if  abs(target_angle) > PI/2 and inv_image_weapon1 == 0:
			weapon_sprite.flip_v = true # Voltear horizontalmente el sprite del arma
			inv_image_weapon1=1
			
		elif abs(target_angle) < PI/2  and inv_image_weapon1 == 1:
			weapon_sprite.flip_v = false # dejarla original
			inv_image_weapon1=0
			
			
	if is_instance_valid(current_weapon2):

		current_weapon2.rotation = lerp_angle(current_weapon2.rotation,target_angle + diferencia_sprit_weapon, 10.0 * delta)  # Ajusta la velocidad de rotación
		var weapon_sprite = current_weapon2.get_node("Sprite2D")  # Sprite del arma
		if  abs(target_angle) > PI/2 and inv_image_weapon2 == 0:
			weapon_sprite.flip_v = true
			inv_image_weapon2=1
			
		elif abs(target_angle) < PI/2  and inv_image_weapon2 == 1:
			weapon_sprite.flip_v = false
			inv_image_weapon2=0
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

func equip_weapon1(_angle:float):
	if arma1_data and arma1_data.arma_escena:
		if is_instance_valid(current_weapon1):
			current_weapon1.queue_free()
	current_weapon1 = arma1_data.arma_escena.instantiate()
	current_weapon1.arma_data = arma1_data  #Asigno el resurse
	weapon_anchor.add_child(current_weapon1)
	current_weapon1.position = Vector2.ZERO
	#
	#if not arma1_scene and not is_instance_valid(weapon_anchor):
		#return
	#if is_instance_valid(current_weapon1):
		#current_weapon1.queue_free()
#
	## Instancia la escena del arma
	#current_weapon1 = weapon1_scene.instantiate()
	#$WeaponAnchor1.add_child(current_weapon1)
	#current_weapon1.position = Vector2.ZERO
	

func equip_weapon2(_angle:float):
	if not weapon2_scene and not is_instance_valid(weapon2_anchor):
		return
		
	# Instancia la escena del arma
	current_weapon2 = weapon2_scene.instantiate()
	$WeaponAnchor2.add_child(current_weapon2)
	current_weapon2.position = Vector2.ZERO
		
func unequip_weapon1(): # desequipar le arma
	if is_instance_valid(current_weapon1):
		remove_child(current_weapon1)
		current_weapon1.queue_free()
		current_weapon1 = null
		#print("Arma desequipada.")

# cambio de armas
func change_weapon(new_weapon_scene: PackedScene):
	unequip_weapon1()
	weapon1_scene = new_weapon_scene
	equip_weapon1(0.0)




	
# Señal recibida desde main_game con el ángulo al enemigo más cercano
func _on_enemy_detected(angle_to_enemy: float):
	target_angle = angle_to_enemy
	shootWeapon1()
	
	
func shootWeapon1():
	if !shooting and current_weapon1:
		shooting = true
		current_weapon1.shoot(muzzle1.global_position, target_angle)
		await get_tree().create_timer(arma1_data.tiempoDisparo).timeout
		shooting = false
	
	
	
#func timer_Shoot1():
	#var shoot1_timer = Timer.new()
	#shoot1_timer.wait_time = time_shoot1
	#shoot1_timer.one_shot = false #que sea ciclico
	#add_child(shoot1_timer)
	#shoot1_timer.start()  # inicia el temporizador
	#shoot1_timer.timeout.connect(shoot1)	
	
func timer_Shoot2():
	var shoot2_timer = Timer.new()
	shoot2_timer.wait_time = time_shoot2
	shoot2_timer.one_shot = false #que sea ciclico
	add_child(shoot2_timer)
	shoot2_timer.start()  # inicia el temporizador
	shoot2_timer.timeout.connect(shoot2)	
		
#func shoot1():  # Disparo hacia el angulo del enemigo mas cercano
	#var shoot1 = shoot1_scene.instantiate()
	#shoot1.global_position = muzzle1.global_position
	#shoot1.rotation = target_angle  # direccion del enemigo
	#shoot1.set_direction(Vector2.from_angle(target_angle))  # Método en la bala
	#get_parent().add_child(shoot1)
	#current_weapon1.play_retroceso()
	
	
func shoot2():  # Disparo hacia el angulo del enemigo mas cercano
	pass
	#var shoot2 = shoot2_scene.instantiate()
	#shoot2.global_position = muzzle2.global_position
	#shoot2.rotation = target_angle
	#shoot2.set_direction(Vector2.from_angle(target_angle))  # Método en la bala
	#get_parent().add_child(shoot2)	
	#current_weapon2.play_retroceso()

# recibir daño
func take_damage(amount: int):
	
	# $AnimationPlayer.play("hit")
	armor = Global.currentPlayer._armor
	var damage_taken = amount * armor
	Global.currentPlayer.take_damage(damage_taken)
	#print (Global.currentPlayer._health, "sacar: ", damage_taken, "armor,", armor)
	if Global.currentPlayer._health <= 0:
		die()

# morir al no tenes mas vidas
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
