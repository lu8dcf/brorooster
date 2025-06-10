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
var margen_spawn = 1.1 * GlobalEnemy.margen_spawn  # margen donde inician los enemigos
var topeX = true # indicador de extremo X
var topeY = true # indicador de extremo Y

var direccion : Vector2
var side : int # de 1 a 4 hacia que direcciuon se dirige
var cambio_timer := Timer.new()  # tiempo de espera par acambio de direccion
var puede_cambiar = true

func _ready():
	original_health = health
	update_health(health)
	
	# Obtener el tamaño de la pantalla 
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
	set_vector(position)
	
func set_vector(vector):
	
	var side = randi() % 2 + 1
	# esta en el borde de X
	if (vector.x <  margen_spawn or vector.x > pantalla_ancho -  margen_spawn) and topeX and puede_cambiar:
		cambio_direccionY()
		
		
	if (vector.y <   margen_spawn or vector.y > pantalla_alto -  margen_spawn)  and topeY and puede_cambiar:	
		cambio_direccionX()
		
		
	
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")	
	movimiento = direccion.normalized() * veloci
	# limites de movimiento
	movimiento.x = clamp(movimiento.x, 0.9 * margen_spawn,pantalla_ancho -  0.9 * margen_spawn)
	movimiento.y = clamp(movimiento.y, 0.9 * margen_spawn,pantalla_alto -  0.9 * margen_spawn)
	print (vector.x ," x ",movimiento.x, " -- ",vector.y , " y ", movimiento.y, " tope ", topeX)

func cambio_direccionY():
	var side = randi() % 2 + 1
	match side:
		1: direccion = Vector2(0,1)  #se dirije hacia abajo
		2: direccion = Vector2(0,-1)  #se dirije hacia arriba
	topeX=false
	topeY=true
	puede_cambiar = false
	
func cambio_direccionX():
	var side = randi() % 2 + 1
	match side:
		1: direccion = Vector2(1,0)  #se dirije hacia derecha
		2: direccion = Vector2(-1,0)  #se dirije hacia izquiersda
	topeY=false	
	topeX=true
	puede_cambiar = false


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
