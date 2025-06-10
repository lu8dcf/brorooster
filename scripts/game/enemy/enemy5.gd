# Araña Boss

extends EnemigoBase
class_name Arania



# Referencia a la escena del enemigo 66 a instanciar cuando recibe daño
@export var enemy6_scene: PackedScene

# Variables internas
var original_health: float

# pantalla
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var margen_spawn = 1.5 * GlobalEnemy.margen_spawn  # margen donde inician los enemigos
var topeX = true # indicador de extremo X
var topeY = true # indicador de extremo Y

var direccion :  Vector2
var side : int # de 1 a 4 hacia que direcciuon se dirige
var cambio_timer := Timer.new()  # tiempo de espera par acambio de direccion
var puede_cambiar = true
var pasox = true  # cuando esta al medio x
var pasoy = true  # cuando esta al medio y
# var screen_size: Vector2


func _ready():
	original_health = health
	update_health(health)
	
	
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)
	
	# Configurar el timer de cambio de direeccion
	cambio_timer.wait_time = 1.5
	cambio_timer.one_shot = false
	cambio_timer.connect("timeout", Callable(self, "_on_salto_timer_timeout"))
	add_child(cambio_timer)
	cambio_timer.start()

func _physics_process(delta):
	
	move_and_collide(movimiento)
	position.x = clamp(position.x, 0.5 * margen_spawn, pantalla_ancho - 0.5 * margen_spawn)
	position.y = clamp(position.y, 0.5 * margen_spawn, pantalla_alto - 0.5 * margen_spawn)
	
	set_vector(position)
	
func set_vector(vector):
		
	if puede_cambiar:
		var side = randi() % 2 + 1
		
		if vector.x <  margen_spawn:    # esta Iquierda
			print ("izquierda")
			if  vector.y <  margen_spawn:  # esta arriba
				match side:
					1: direccion = Vector2(1,0)  #se dirije hacia derecha
					2: direccion = Vector2(0,1)  #se dirije hacia abajo
			
			if  vector.y >   pantalla_alto - margen_spawn:  # esta abajo
				match side:
					1: direccion = Vector2(1,0)  #se dirije hacia derecha
					2: direccion = Vector2(0,-1)  #se dirije hacia arriba
			
					
		elif vector.x >  pantalla_ancho - margen_spawn:  # esta en la derecha
			print ("derecha")
			if  vector.y <  margen_spawn:  # esta arriba
				match side:
					1: direccion = Vector2(-1,0)  #se dirije hacia izq
					2: direccion = Vector2(0,1)  #se dirije hacia abajo
			if  vector.y >   pantalla_alto - margen_spawn:  # estaarriba
				match side:
					1: direccion = Vector2(-1,0)  #se dirije hacia izq
					2: direccion = Vector2(0,1)  #se dirije hacia arriba  # esta abajo			
		
		if vector.x <=  pantalla_ancho - margen_spawn and vector.x >  margen_spawn and  pasox:
				match side:
					1: direccion = Vector2(-1,0)  #se dirije hacia izq
					2: direccion =  Vector2(1,0)  #se dirije hacia derecha		
				pasox= false
				
		
		elif vector.y <=  pantalla_alto - margen_spawn and vector.y >  margen_spawn and  pasoy:
				match side:
					1: direccion = Vector2(0,-1)  #se dirije hacia arriba
					2: direccion =  Vector2(0,1)  #se dirije hacia abajo		
				pasoy= false
		puede_cambiar= false
	
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")	
	movimiento = direccion * veloci
	# limites de movimiento
	
func take_damage(amount: float):
	health -= amount
	update_health(health)
	if health <= 0:
		die()

func update_health(value: float):
	$HealthBar/ProgressBar.value = value

func spawn_minions():
	if enemy6_scene:
		for i in range(2):
			var minion = enemy6_scene.instantiate()
			
			# Configurar posición cerca del enemigo actual
			var offset = Vector2(randf_range(-30, 30), randf_range(-30, 30))
			minion.position = position + offset
			
			# Agregar a la escena (asumiendo que este enemigo está en el árbol principal)
			get_parent().add_child(minion)

func die():
	# Aquí puedes agregar efectos de muerte, sonidos, etc.
	queue_free()

func _on_salto_timer_timeout():
	puede_cambiar = true
