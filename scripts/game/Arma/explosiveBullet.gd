extends bulletClass

var tiempoAExplotar = .3;
var explotar = false

#Constructor


func setup(damage_value: float, direction_value: Vector2):
	tipo = "B"
	damage = damage_value
	direction = direction_value
	

func _ready():
	await get_tree().create_timer(tiempoAExplotar).timeout
	Explotar()
	$sonido_disparo.play() # Sonido del laser a disparar
	
	
func _physics_process(delta):
	if(!explotar):
		position += direction * speed  * delta # Mover el disparo
		# Si el láser sale de la pantalla, se elimina
		if position.y < 0 or position.x < 0:  # falta agregar los exptremos para cuando la bala salga de pantalla
			queue_free()


func set_direction(dir: Vector2): # Direccion de la bala
	direction = dir


func Explotar():
	speed = 0
	explotar = true
	
	await get_tree().process_frame # Un frame de tiempo para registrar colisiones

	# Obtener cuerpos dentro del Area
	var cuerpos_en_area = $ExplosionArea.get_overlapping_bodies()
	for cuerpo in cuerpos_en_area:
		if cuerpo.is_in_group("enemies") and cuerpo.has_method("take_damage"):
			cuerpo.take_damage(damage)

	queue_free()
