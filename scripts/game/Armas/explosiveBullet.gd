extends bulletClass

var tiempoAExplotar = .5;
var explotar = false



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
	await get_tree().create_timer(.3).timeout #esperar un segundito
	var cuerpos_en_area = $".".get_overlapping_bodies() #lista con los objetos en el area
	for cuerpo in cuerpos_en_area: #dañar a los objetos del area
		if cuerpo.is_in_group("enemies") and cuerpo.has_method("take_damage"):
			cuerpo.take_damage(damage)

	queue_free()
	pass # Replace with function body.
